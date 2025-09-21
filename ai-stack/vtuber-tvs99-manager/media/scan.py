import os
from typing import List, Dict

MEDIA_ROOTS = [
    '/media',
    '/mnt',
    '/srv/media',
    '../media-stack',
]

VIDEO_EXTS = {'.mp4', '.mkv', '.avi', '.mov', '.webm'}
AUDIO_EXTS = {'.mp3', '.flac', '.wav', '.ogg', '.aac'}
IMAGE_EXTS = {'.jpg', '.jpeg', '.png', '.gif', '.bmp'}


def scan_media(root_dirs: List[str] = MEDIA_ROOTS) -> Dict[str, List[str]]:
    media = {'video': [], 'audio': [], 'image': []}
    for root in root_dirs:
        for dirpath, _, files in os.walk(root):
            for f in files:
                ext = os.path.splitext(f)[1].lower()
                path = os.path.join(dirpath, f)
                if ext in VIDEO_EXTS:
                    media['video'].append(path)
                elif ext in AUDIO_EXTS:
                    media['audio'].append(path)
                elif ext in IMAGE_EXTS:
                    media['image'].append(path)
    return media

if __name__ == "__main__":
    import json
    found = scan_media()
    print(json.dumps(found, indent=2))
