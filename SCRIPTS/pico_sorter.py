import os
import re
import sys
import shutil
import essentia.standard as es
from pydub import AudioSegment
from ollama import Client
from sf2utils.sf2parse import Sf2File

# --- CONFIGURATION ---
INPUT_DIR = os.getenv('INPUT_DIR', '/app/unsorted_samples')
OUTPUT_DIR = os.getenv('OUTPUT_DIR', '/app/sorted_samples')
OLLAMA_URL = os.getenv('OLLAMA_URL', 'http://ollama:11434')
MODEL = os.getenv('OLLAMA_MODEL', 'llama3')
DRY_RUN = os.getenv('DRY_RUN', 'False').lower() == 'true'
TARGET_GENRES = os.getenv('TARGET_GENRES', 'Jungle, Breakcore, Lo-Fi, Techno')

client = Client(host=OLLAMA_URL)

AUDIO_VIDEO = (
    '.avi', '.flac', '.flv', '.m4a', '.mov', '.mp3', '.mp4', '.mpv', 
    '.ogg', '.ogv', '.oga', '.wav', '.wma', '.wmv', '.aiff', '.aif', 
    '.aifc', '.opus', '.wv', '.ape', '.au', '.xi'
)

def clean_filename(filename):
    name = "".join([c for c in filename if c.isalnum() or c in (' ', '.', '_', '-')]).strip()
    return name[:60]

def analyze_audio_file(file_path):
    try:
        loader = es.MonoLoader(filename=file_path, sampleRate=44100)
        audio = loader()
        duration = es.Duration()(audio)
        bpm, _, confidence, _, _ = es.RhythmExtractor2013()(audio)
        return {"duration": round(duration, 2), "bpm": round(bpm, 1), "is_rhythmic": confidence > 1.2}
    except:
        return {"duration": 0, "bpm": 0, "is_rhythmic": False}

def get_ai_decision(stats, filename, pack_name):
    prompt = f"""
    Act as a professional music producer. Genre Context: {TARGET_GENRES}.
    Analyze: Filename '{filename}', Pack '{pack_name}', Duration {stats['duration']}s, BPM {stats['bpm']}.
    Task: Categorize for a hardware tracker (PicoTracker).
    Format: TYPE | CATEGORY
    Options: Kick, Snare, Hihat, Perc, Bass-Stab, Synth, Vocals, FX, Drumbreak, Texture.
    Rule: Fast rhythmic loops (>160 BPM) = Drumbreak.
    Response: TYPE | CATEGORY
    """
    try:
        response = client.generate(model=MODEL, prompt=prompt)
        raw_res = response['response'].strip().split('\n')[-1]
        parts = raw_res.split('|')
        return [p.strip() for p in parts] if len(parts) == 2 else ["One-Shot", "Unsorted"]
    except:
        return ["One-Shot", "Unsorted"]

def save_for_pico(audio_segment, original_filename, s_type, category, pack_name):
    clean_name = clean_filename(original_filename)
    if not clean_name.lower().endswith('.wav'): clean_name += '.wav'
    if DRY_RUN:
        print(f"🧪 [DRY] Would save: {clean_name} to {s_type}/{category}/{pack_name}")
        return
    audio_segment = audio_segment.set_frame_rate(44100).set_sample_width(2).set_channels(1)
    target_dir = os.path.join(OUTPUT_DIR, s_type, category, pack_name)
    os.makedirs(target_dir, exist_ok=True)
    audio_segment.export(os.path.join(target_dir, clean_name), format="wav")

def handle_sf2(file_path, pack_name):
    print(f"📦 Extracting SF2: {file_path}")
    try:
        with open(file_path, 'rb') as f:
            sf2 = Sf2File(f)
            for sample in sf2.samples:
                if sample.data:
                    audio = AudioSegment(sample.data, frame_rate=sample.sample_rate, sample_width=2, channels=1)
                    temp_wav = f"/tmp/sf2_{sample.name}.wav"
                    audio.export(temp_wav, format="wav")
                    stats = analyze_audio_file(temp_wav)
                    os.remove(temp_wav)
                    decision = get_ai_decision(stats, sample.name, f"{pack_name}_SF2")
                    save_for_pico(audio, sample.name, decision[0], decision[1], pack_name)
    except Exception as e: print(f"❌ SF2 Error: {e}")

def cleanup_empty_folders(path):
    """Recursively removes empty directories"""
    if not os.path.isdir(path): return
    for root, dirs, files in os.walk(path, topdown=False):
        for name in dirs:
            full_path = os.path.join(root, name)
            if not os.listdir(full_path):
                if not DRY_RUN:
                    os.rmdir(full_path)
                    print(f"🗑️ Removed empty folder: {name}")
                else:
                    print(f"🧪 [DRY] Would remove empty folder: {name}")

def process_file(full_path, filename, pack_name):
    ext = os.path.splitext(filename)[1].lower()
    if ext == '.sf2': handle_sf2(full_path, pack_name)
    elif ext == '.sfz':
        base_dir = os.path.dirname(full_path)
        with open(full_path, 'r', errors='ignore') as f:
            samples = re.findall(r'sample=([^\s\r\n]+)', f.read())
            for s in samples:
                s_path = os.path.join(base_dir, s.replace('\\', '/').strip('"'))
                if os.path.exists(s_path): process_file(s_path, os.path.basename(s_path), pack_name)
    elif ext in AUDIO_VIDEO:
        try:
            audio = AudioSegment.from_file(full_path)
            temp_path = f"/tmp/proc_{filename}.wav"
            audio.set_frame_rate(44100).set_channels(1).export(temp_path, format="wav")
            stats = analyze_audio_file(temp_path)
            decision = get_ai_decision(stats, filename, pack_name)
            save_for_pico(audio, filename, decision[0], decision[1], pack_name)
            if os.path.exists(temp_path): os.remove(temp_path)
            print(f"✅ {decision[0]}/{decision[1]}: {filename}")
        except Exception as e: print(f"❌ Error {filename}: {e}")

if __name__ == "__main__":
    print(f"🚀 AI Sorter Start. Genre: {TARGET_GENRES}")
    for root, _, files in os.walk(INPUT_DIR):
        rel = os.path.relpath(root, INPUT_DIR)
        pack = rel.split(os.sep)[0] if rel != "." else "Loose_Samples"
        for file in files:
            process_file(os.path.join(root, file), file, pack)
    
    print("🧹 Starting cleanup of empty folders...")
    cleanup_empty_folders(OUTPUT_DIR)
    print("✨ Done.")
