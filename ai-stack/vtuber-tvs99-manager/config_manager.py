import yaml
from typing import List, Dict, Any
import os

CONFIG_PATH = os.environ.get("TVS99_CONFIG", "../tvs99/config.tvs.yml")


def load_config(path: str = CONFIG_PATH) -> Dict[str, Any]:
    with open(path, 'r') as f:
        return yaml.safe_load(f)

def save_config(config: Dict[str, Any], path: str = CONFIG_PATH):
    with open(path, 'w') as f:
        yaml.dump(config, f, sort_keys=False, allow_unicode=True)

def list_channels(config: Dict[str, Any]) -> List[Dict[str, Any]]:
    return config.get('channels', [])

def add_channel(config: Dict[str, Any], channel: Dict[str, Any]):
    config.setdefault('channels', []).append(channel)

def update_channel(config: Dict[str, Any], number: int, updates: Dict[str, Any]):
    for ch in config.get('channels', []):
        if ch.get('number') == number:
            ch.update(updates)
            break

def remove_channel(config: Dict[str, Any], number: int):
    config['channels'] = [ch for ch in config.get('channels', []) if ch.get('number') != number]

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Manage TVS99 config.tvs.yml")
    parser.add_argument('--list', action='store_true', help='List channels')
    parser.add_argument('--add', nargs=3, metavar=('NUMBER', 'NAME', 'CONTENT'), help='Add channel')
    parser.add_argument('--remove', type=int, metavar='NUMBER', help='Remove channel by number')
    parser.add_argument('--update', nargs=2, metavar=('NUMBER', 'TITLE'), help='Update channel title')
    args = parser.parse_args()

    config = load_config()

    if args.list:
        for ch in list_channels(config):
            print(f"{ch.get('number')}: {ch.get('name')} - {ch.get('title', '')}")
    if args.add:
        number, name, content = args.add
        add_channel(config, {'number': int(number), 'name': name, 'title': '', 'video': content})
        save_config(config)
        print(f"Added channel {number}: {name}")
    if args.remove:
        remove_channel(config, args.remove)
        save_config(config)
        print(f"Removed channel {args.remove}")
    if args.update:
        number, title = args.update
        update_channel(config, int(number), {'title': title})
        save_config(config)
        print(f"Updated channel {number} title to {title}")
