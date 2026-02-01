#!/usr/bin/env python3
import sys, requests, os, subprocess, shutil, time

# Configuratie
DEBUG = os.getenv("DEBUG") == "on" or "--debug" in sys.argv
DOWNLOAD_DIR = os.getenv('SHOWOUET_DOWNLOADS', '/config/Downloads')
EXTRACT_DIR = os.path.join(DOWNLOAD_DIR, "current_demo")
HEADERS = {'User-Agent': 'ShowouetJukebox/4.0', 'Accept': 'application/json'}
CORE_DIR = "/usr/lib/x86_64-linux-gnu/libretro"
INFO_DIR = "/usr/share/libretro/info"

# Mapping gesynchroniseerd met Ubuntu libretro-* pakketten
PLATFORM_MAPPING = {
    "Windows": "wine",
    "MS-Dos": "dosbox_pure_libretro.so",
    "MS-Dos/gus": "dosbox_pure_libretro.so",
    "Linux": "native",
    "Amiga AGA": "puae_libretro.so",
    "Amiga OCS/ECS": "puae_libretro.so",
    "Amiga PPC/RTG": "puae_libretro.so",
    "Atari ST": "hatari_libretro.so",
    "Atari STe": "hatari_libretro.so",
    "Atari Falcon 030": "hatari_libretro.so",
    "Atari TT 030": "hatari_libretro.so",
    "Atari XL/XE": "atari800_libretro.so",
    "Atari VCS": "stella_libretro.so",
    "Atari Jaguar": "virtualjaguar_libretro.so",
    "Atari Lynx": "handy_libretro.so",
    "Atari 7800": "prosystem_libretro.so",
    "Commodore 64": "vice_x64sc_libretro.so",
    "Commodore 128": "vice_x128_libretro.so",
    "VIC 20": "vice_xvic_libretro.so",
    "C16/116/plus4": "vice_xplus4_libretro.so",
    "Commodore PET": "vice_xpet_libretro.so",
    "C64 DTV": "vice_x64dtv_libretro.so",
    "ZX Spectrum": "fuse_libretro.so",
    "ZX Enhanced": "fuse_libretro.so",
    "ZX-81": "81_libretro.so",
    "Amstrad CPC": "caprice32_libretro.so",
    "Amstrad Plus": "caprice32_libretro.so",
    "MSX": "fmsx_libretro.so",
    "MSX 2": "fmsx_libretro.so",
    "MSX 2 plus": "fmsx_libretro.so",
    "MSX Turbo-R": "fmsx_libretro.so",
    "NES/Famicom": "nestopia_libretro.so",
    "SNES/Super Famicom": "snes9x_libretro.so",
    "Nintendo 64": "mupen64plus_next_libretro.so",
    "Nintendo DS": "desmume_libretro.so",
    "Nintendo Wii": "dolphin_libretro.so",
    "Gameboy": "gambatte_libretro.so",
    "Gameboy Color": "gambatte_libretro.so",
    "Gameboy Advance": "mgba_libretro.so",
    "Pokemon Mini": "pokemini_libretro.so",
    "Virtual Boy": "beetle_vb_libretro.so",
    "Playstation": "mednafen_psx_libretro.so",
    "Playstation 2": "pcsx2_libretro.so",
    "Playstation Portable": "ppsspp_libretro.so",
    "SEGA Genesis/Mega Drive": "genesis_plus_gx_libretro.so",
    "SEGA Master System": "genesis_plus_gx_libretro.so",
    "SEGA Game Gear": "genesis_plus_gx_libretro.so",
    "Dreamcast": "flycast_libretro.so",
    "NEC TurboGrafx/PC Engine": "mednafen_pce_fast_libretro.so",
    "Apple II": "apple2enh_libretro.so",
    "Apple II GS": "apple2enh_libretro.so",
    "Acorn": "arcem_libretro.so",
    "Oric": "oricutron_libretro.so",
    "Vectrex": "vecx_libretro.so",
    "PICO-8": "retro8_libretro.so",
    "TIC-80": "tic80_libretro.so",
    "NeoGeo Pocket": "mednafen_ngp_libretro.so",
    "Wonderswan": "mednafen_wswan_libretro.so"
}

def get_supported_extensions():
    """Leest de supported_extensions uit libretro .info bestanden."""
    exts = {'.exe', '.com'}
    ignore = {'zip', '7z', 'rar', 'tar', 'gz', 'lha', 'lz'}
    if os.path.exists(INFO_DIR):
        for f in os.listdir(INFO_DIR):
            if f.endswith(".info"):
                try:
                    with open(os.path.join(INFO_DIR, f), 'r') as info:
                        for line in info:
                            if line.startswith("supported_extensions"):
                                raw = line.split('=')[-1].strip().replace('"', '')
                                for p in raw.split('|'):
                                    p = p.strip().lower()
                                    if p and p not in ignore:
                                        exts.add("." + p)
                except: pass
    return tuple(exts)

def safe_get_json(url, params=None):
    if DEBUG: print(f"[DEBUG] AANROEP: {url} | PARAMS: {params}")
    try:
        r = requests.get(url, params=params, headers=HEADERS, timeout=15)
        r.raise_for_status()
        return r.json()
    except Exception as e:
        print(f"\n[!] API FOUT: {e}")
        return None

def launch(work_dir, meta):
    target = None
    exts = get_supported_extensions()

    for root, _, files in os.walk(work_dir):
        for f in sorted(files):
            if f.lower().endswith(exts):
                target = os.path.join(root, f)
                break
        if target: break

    if not target:
        print("\x1b[31m[!] Geen ondersteund bestand gevonden na extractie.\x1b[0m")
        return

    p_list = meta.get('p_list', [])
    print(f"\n\x1b[32m▶ Starten: {meta['name']} ({', '.join(p_list)})\x1b[0m")

    core = None
    for p_name in p_list:
        if p_name in PLATFORM_MAPPING:
            core = PLATFORM_MAPPING[p_name]
            break

    try:
        if core == "wine":
            subprocess.run(["wine", target], cwd=os.path.dirname(target))
        elif core and core.endswith(".so"):
            c_path = os.path.join(CORE_DIR, core)
            cmd = ["retroarch", "-L", c_path] if os.path.exists(c_path) else ["retroarch"]
            cmd.append(target)
            subprocess.run(cmd)
        elif core == "native":
            os.chmod(target, 0o755)
            subprocess.run([target], cwd=os.path.dirname(target))
        else:
            subprocess.run(["retroarch", target])
    except Exception as e:
        print(f"[!] Emulator error: {e}")

def process(prod_id):
    # API v1 prod endpoint
    data = safe_get_json("https://api.pouet.net/v1/prod/", params={'id': prod_id})
    prod = data.get('prod') if data else None
    if not prod:
        print(f"[!] Geen data gevonden voor ID {prod_id}")
        return

    url = prod.get('download')
    if not url:
        print("[!] Geen download-URL gevonden.")
        return

    shutil.rmtree(EXTRACT_DIR, ignore_errors=True)
    os.makedirs(EXTRACT_DIR, exist_ok=True)
    tmp_path = os.path.join(DOWNLOAD_DIR, "file.tmp")

    print(f"Downloading: {prod.get('name')}...")
    try:
        with requests.get(url, stream=True, timeout=30, headers=HEADERS) as r:
            r.raise_for_status()
            with open(tmp_path, 'wb') as f: shutil.copyfileobj(r.raw, f)

        subprocess.run(["7z", "x", tmp_path, f"-o{EXTRACT_DIR}", "-y"], stdout=subprocess.DEVNULL)

        # Verbeterde platform-extractie: handle zowel list als dict structuren
        raw_platforms = prod.get('platforms', [])
        p_names = []
        if isinstance(raw_platforms, dict):
            p_names = [p['name'] for p in raw_platforms.values() if 'name' in p]
        elif isinstance(raw_platforms, list):
            p_names = [p['name'] for p in raw_platforms if 'name' in p]

        launch(EXTRACT_DIR, {"name": prod.get('name'), "p_list": p_names})
        input("\n[Enter] voor menu...")
    except Exception as e:
        print(f"[!] Verwerkingsfout: {e}")

def main():
    while True:
        print("\n===========================================")
        print("    POUËT.NET JUKEBOX V4.0 (DYNAMIC)      ")
        print("===========================================")
        print("1. Random Demo\n2. Latest Released\n3. Top of the Month\n4. All-time Top\n5. Exit")

        c = input("\nKeuze: ")

        endpoints = {
            "1": "https://api.pouet.net/v1/prod/?random=true",
            "2": "https://api.pouet.net/v1/front-page/latest-released/",
            "3": "https://api.pouet.net/v1/front-page/top-of-the-month/",
            "4": "https://api.pouet.net/v1/front-page/alltime-top/"
        }

        if c == "1":
            res = safe_get_json(endpoints["1"])
            # Voor random prods zit de data soms direct in 'prod'
            if res and 'prod' in res:
                process(res['prod']['id'])
        elif c in ["2", "3", "4"]:
            data = safe_get_json(endpoints[c])
            if data:
                # Zoek dynamisch naar de lijst met prods (keys variëren per endpoint)
                items = next((v for v in data.values() if isinstance(v, list)), [])
                if items:
                    print("\nSelecteer een demo:")
                    for i, item in enumerate(items[:15]):
                        print(f"{i+1:2}. {item['name']}")
                    sel = input("\nNummer (q=menu): ")
                    if sel.isdigit() and 0 < int(sel) <= len(items):
                        process(items[int(sel)-1]['id'])
        elif c == "5":
            break

if __name__ == "__main__":
    main()
