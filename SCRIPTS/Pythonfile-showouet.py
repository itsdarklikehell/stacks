#!/usr/bin/env python3
import sys
import requests
import os
import subprocess
import shutil
import zipfile
import tarfile
import time
import webbrowser
import logging
from logging.handlers import RotatingFileHandler
from typing import Any, Dict, List, Optional, Tuple, Union, Mapping, cast
import platform
import psutil


# === CONFIGURATIE ===
DEBUG = os.getenv("DEBUG") == "on" or "--debug" in sys.argv
DOWNLOAD_DIR = os.getenv('SHOWOUET_DOWNLOADS', '/config/Downloads')
LOG_DIR = os.getenv('SHOWOUET_LOGS', '/config/logs')
EXTRACT_DIR = os.path.join(DOWNLOAD_DIR, "current_demo")

# Logging setup
os.makedirs(LOG_DIR, exist_ok=True)
logger = logging.getLogger('showouet')
logger.setLevel(logging.DEBUG if DEBUG else logging.INFO)

formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

# File handler met rotation (10MB, 5 backups)
fh = RotatingFileHandler(
    os.path.join(LOG_DIR, 'showouet.log'),
    maxBytes=10485760,
    backupCount=5
)
fh.setLevel(logging.DEBUG)
fh.setFormatter(formatter)
logger.addHandler(fh)

# Console handler
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG if DEBUG else logging.INFO)
ch.setFormatter(formatter)
logger.addHandler(ch)


def format_size(bytes_size: Union[int, float]) -> str:
    """Format bytes to human readable format."""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if bytes_size < 1024.0:
            return f"{bytes_size:.1f}{unit}"
        bytes_size /= 1024.0
    return f"{bytes_size:.1f}TB"


def log_system_info() -> None:
    """Log system info voor debugging."""
    logger.info("=" * 60)
    logger.info("SHOWOUET SYSTEM INFO")
    logger.info("=" * 60)
    logger.info("Python: %s", sys.version)
    logger.info("Platform: %s", platform.platform())
    logger.info("Architecture: %s", platform.machine())
    logger.info("CPU Count: %s", os.cpu_count())

    try:
        mem = psutil.virtual_memory()
        logger.info("Memory: %.1fGB total, %.1fGB available",
                    mem.total / (1024**3), mem.available / (1024**3))
        disk = psutil.disk_usage('/')
        logger.info("Disk: %.1fGB total, %.1fGB free",
                    disk.total / (1024**3), disk.free / (1024**3))
    except (OSError, AttributeError) as e:
        logger.warning("Could not get system resources: %s", e)

    logger.info("DEBUG mode: %s", DEBUG)
    logger.info("Download dir: %s", DOWNLOAD_DIR)
    logger.info("Log dir: %s", LOG_DIR)
    logger.info("Core dir: %s", CORE_DIR)
    logger.info("Info dir: %s", INFO_DIR)
    logger.info("=" * 60)


def check_available_tools() -> None:
    """Check welke tools beschikbaar zijn."""
    tools = {
        'retroarch': 'RetroArch',
        'wine': 'Wine',
        'winetricks': 'Winetricks',
        '7z': '7-Zip',
        'lha': 'LHA',
        'xfce4-terminal': 'XFCE Terminal',
        'firefox': 'Firefox',
        'wineboot': 'Wineboot'
    }

    logger.info("Available tools:")
    for cmd, name in tools.items():
        try:
            result = subprocess.run(
                ['which', cmd],
                capture_output=True,
                timeout=5,
                check=False
            )
            available = result.returncode == 0
            status = "✓" if available else "✗"
            logger.info("  %s %s (%s)", status, name.ljust(20), cmd)
        except (OSError, subprocess.TimeoutExpired) as e:
            logger.warning("  ? %s (check failed: %s)", name.ljust(20), e)

    # Check libretro cores
    if os.path.exists(CORE_DIR):
        cores = [f for f in os.listdir(CORE_DIR) if f.endswith('.so')]
        logger.info("Found %d libretro cores", len(cores))
        if DEBUG and cores:
            for core in sorted(cores)[:10]:
                logger.debug("    - %s", core)
            if len(cores) > 10:
                logger.debug("    ... and %d more", len(cores) - 10)
    else:
        logger.warning("Libretro core dir not found: %s", CORE_DIR)


# Browser-spoof headers om API-blokkades te voorkomen
HEADERS = {
    'User-Agent': 'PouetJukebox/0.4-Alpha (Ubuntu-Webtop)',
    'Accept': 'application/json'
}

CORE_DIR = "/usr/lib/x86_64-linux-gnu/libretro"
INFO_DIR = "/usr/share/libretro/info"

# === PLATFORM MAPPING ===
PLATFORM_MAPPING = {
    "Windows": "wine",
    "Linux": "native",
    "BeOS": "native",
    "MacOSX Intel": "native",
    "MS-Dos": "dosbox_pure_libretro.so",
    "MS-Dos/gus": "dosbox_pure_libretro.so",
    "Amiga AGA": "puae_libretro.so",
    "Amiga OCS/ECS": "puae_libretro.so",
    "Amiga PPC/RTG": "puae_libretro.so",
    "Atari ST": "hatari",
    "Atari STe": "hatari",
    "Atari Falcon 030": "hatari",
    "Atari TT 030": "hatari",
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
    "C64DX/C65/MEGA65": "vice_x64sc_libretro.so",
    "ZX Spectrum": "fuse_libretro.so",
    "ZX Enhanced": "fuse_libretro.so",
    "ZX-81": "81_libretro.so",
    "Sinclair QL": "s_ql_libretro.so",
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
    "SEGA Genesis/Mega Drive": "genesis_plus_gx_libretro.so",
    "SEGA Master System": "genesis_plus_gx_libretro.so",
    "SEGA Game Gear": "genesis_plus_gx_libretro.so",
    "Dreamcast": "flycast_libretro.so",
    "Playstation": "mednafen_psx_libretro.so",
    "Playstation 2": "pcsx2_libretro.so",
    "Playstation Portable": "ppsspp_libretro.so",
    "NEC TurboGrafx/PC Engine": "mednafen_pce_fast_libretro.so",
    "Apple II": "apple2enh_libretro.so",
    "Apple II GS": "apple2enh_libretro.so",
    "Acorn": "arcem_libretro.so",
    "Oric": "oricutron_libretro.so",
    "Vectrex": "vecx_libretro.so",
    "PICO-8": "retro8_libretro.so",
    "TIC-80": "retro8_libretro.so",
    "NeoGeo Pocket": "mednafen_ngp_libretro.so",
    "Wonderswan": "mednafen_wswan_libretro.so",
    "BBC Micro": "b_em_libretro.so",
    "JavaScript": "browser",
    "Java": "browser",
    "Flash": "browser",
    "Animation/Video": "browser",
    "Wild": "browser"
}

# === CORE LOGICA ===


def safe_get_json(url: str,
                  params: Optional[Dict[str, Any]] = None,
                  retries: int = 3) -> Optional[Dict[str, Any]]:
    """Haalt JSON op met retry logic."""
    for attempt in range(retries):
        try:
            logger.debug("API request: %s | Params: %s", url, params)
            r = requests.get(url, params=params, headers=HEADERS, timeout=15)
            r.raise_for_status()
            logger.debug("API success: %s", url)
            return r.json()
        except requests.exceptions.Timeout:
            logger.warning("API timeout (attempt %d/%d): %s",
                           attempt + 1, retries, url)
            if attempt < retries - 1:
                time.sleep(2 ** attempt)  # Exponential backoff
        except requests.exceptions.ConnectionError as e:
            logger.warning("API connection error (attempt %d/%d): %s",
                           attempt + 1, retries, e)
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
        except requests.exceptions.HTTPError as e:
            logger.error("API HTTP error: %s", e)
            return None
        except ValueError as e:
            logger.error("API JSON decode error: %s", e)
            return None
        except requests.exceptions.RequestException as e:
            logger.error("Unexpected API error: %s", e, exc_info=True)
            return None

    logger.error("API failed after %d retries: %s", retries, url)
    print(f"\n[!] API onbereikbaar na {retries} pogingen")
    return None


def setup_wine_prefix(prefix_dir: str) -> None:
    """Maakt een Wine prefix op en installeert common libraries."""
    logger.info("Wine prefix setup: %s", prefix_dir)
    print("\n\x1b[33m⚙️ Wine prefix instellen...\x1b[0m")
    os.environ['WINEPREFIX'] = prefix_dir
    os.environ['WINEARCH'] = 'win64'

    try:
        # Prefix initialisatie
        logger.debug("Initializing Wine prefix...")
        result = subprocess.run(
            ["wineboot", "-i"], timeout=60, capture_output=True, check=False)
        if result.returncode != 0:
            logger.warning("wineboot returned %d", result.returncode)

        # Common libraries met winetricks
        common_libs = ["dotnet48", "d3dx9",
                       "d3dcompiler_43", "vcrun2019", "dxvk"]
        for lib in common_libs:
            print(f"  Installing {lib}...", end=" ", flush=True)
            logger.debug("Installing winetricks: %s", lib)
            result = subprocess.run(
                ["winetricks", "-q", lib],
                timeout=300,
                capture_output=True,
                check=False
            )
            if result.returncode == 0:
                print("✓")
                logger.debug("Successfully installed %s", lib)
            else:
                print("✗")
                stderr_text = result.stderr.decode('utf-8', errors='ignore')
                logger.warning("Failed to install %s: %s", lib, stderr_text)
    except subprocess.TimeoutExpired as e:
        logger.error("Winetricks timeout: %s", e)
        print("  [!] Timeout")
    except FileNotFoundError as e:
        logger.error("Winetricks not found: %s", e)
        print("  [!] Winetricks niet geïnstalleerd")
    except OSError as e:
        logger.error("Wine prefix setup error: %s", e, exc_info=True)
        print(f"  [!] Error: {e}")

    logger.info("Wine prefix ready")
    print("\x1b[32m✓ Wine prefix gereed\x1b[0m")


def extract_filename(
    url: str,
    response_headers: Optional[Mapping[str, Any]] = None,
) -> str:
    """Extract filename from URL or response headers."""
    filename = None

    # Try Content-Disposition header first
    if response_headers:
        cd = response_headers.get('content-disposition', '')
        if 'filename=' in cd:
            # Extract filename from header
            filename = cd.split('filename=')[-1].strip('"\'')
            logger.debug("Filename from header: %s", filename)

    # Fallback to URL path
    if not filename:
        from urllib.parse import urlparse, unquote
        try:
            path = unquote(urlparse(url).path)
            filename = os.path.basename(path)
            logger.debug("Filename from URL: %s", filename)
        except (ValueError, AttributeError) as e:
            logger.warning("Could not extract filename: %s", e)

    # Sanitize filename (remove path traversal attempts)
    if filename:
        filename = os.path.basename(filename)
        # Remove invalid characters
        filename = "".join(c for c in filename
                           if c.isalnum() or c in '.-_')

    # Fallback if still empty
    if not filename:
        filename = "demo.zip"
        logger.warning("Using default filename: demo.zip")

    return filename


def download_file(url: str, prod_name: str) -> str:
    """Download file with progress and return path."""
    start_time = time.time()
    try:
        with requests.get(url, stream=True, timeout=30,
                          headers=HEADERS, allow_redirects=True) as r:
            r.raise_for_status()

            # Extract filename
            filename = extract_filename(url, r.headers)
            file_path = os.path.join(DOWNLOAD_DIR, filename)

            logger.info("Downloading to: %s", filename)
            print(f"\n\x1b[36m⬇️  Downloading: {prod_name}\x1b[0m")
            print(f"  File: {filename}")

            total_size = int(r.headers.get('content-length', 0))
            downloaded = 0
            chunk_size = 8192

            logger.info("File size: %s", format_size(total_size))
            if total_size > 0:
                print(f"  Size: {format_size(total_size)}")

            with open(file_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=chunk_size):
                    if chunk:
                        f.write(chunk)
                        downloaded += len(chunk)
                        if total_size > 0:
                            percent = (downloaded / total_size) * 100
                            speed = downloaded / (time.time() - start_time)
                            eta = ((total_size - downloaded) / speed
                                   if speed > 0 else 0)
                            bar = ('█' * int(percent / 5) +
                                   '░' * (20 - int(percent / 5)))
                            print(f"  [{bar}] {percent:.1f}% "
                                  f"({format_size(downloaded)}/"
                                  f"{format_size(total_size)}) "
                                  f"@ {format_size(speed)}/s "
                                  f"ETA: {int(eta)}s", end='\r')

            elapsed = time.time() - start_time
            speed = format_size(downloaded / elapsed) if elapsed > 0 else 'N/A'
            logger.info("Download complete: %s in %.1fs (%s/s)",
                        format_size(downloaded), elapsed, speed)
            print(f"\n  ✓ Download complete ({elapsed:.1f}s)")

            return file_path
    except requests.exceptions.RequestException as e:
        logger.error("Download failed: %s", e)
        raise


def get_supported_extensions() -> Tuple[str, ...]:
    """Haalt ondersteunde extensies op uit libretro .info bestanden."""
    exts: set[str] = set()

    if os.path.exists(INFO_DIR):
        for f in os.listdir(INFO_DIR):
            if f.endswith(".info"):
                try:
                    with open(os.path.join(INFO_DIR, f), 'r',
                              encoding='utf-8') as info:
                        for line in info:
                            if line.startswith("supported_extensions"):
                                raw = line.split(
                                    '=')[-1].strip().replace('"', '')
                                for p in raw.split('|'):
                                    p = p.strip().lower()
                                    if p:
                                        exts.add("." + p)
                except (OSError, IOError):
                    pass

    logger.debug("Found %d supported extensions from libretro",
                 len(exts))
    return tuple(exts)


def launch(work_dir: Optional[str], meta: Dict[str, Any]) -> None:
    """Start de productie met de juiste emulator."""
    logger.info("Launching: %s | Platforms: %s",
                meta.get('name'), meta.get('p_list'))
    p_list = meta.get('p_list', [])
    core = next((PLATFORM_MAPPING[p]
                for p in p_list if p in PLATFORM_MAPPING), None)

    if core == "browser":
        url = meta.get('url')
        if isinstance(url, str):
            logger.info("Opening browser: %s", url)
            print(f"\n\x1b[34m🌐 Openen in browser: {url}\x1b[0m")
            try:
                webbrowser.open(url)
            except OSError as e:
                logger.error("Browser open error: %s", e)
        else:
            logger.warning("Invalid URL for browser: %s", url)
            print("[!] Ongeldige URL voor browser")
        return

    target = None
    exts = get_supported_extensions()
    if work_dir:
        for root, _, files in os.walk(work_dir):
            for f in sorted(files):
                if f.lower().endswith(exts):
                    target = os.path.join(root, f)
                    break
            if target:
                break

    if not target:
        logger.warning("No executable found in %s", work_dir)
        print("\x1b[31m[!] Geen ondersteund bestand gevonden.\x1b[0m")
        return

    logger.info("Target: %s", target)
    logger.info("Platforms: %s -> %s", p_list, core)
    print(f"\n\x1b[32m▶ Starten: {meta['name']} ({', '.join(p_list)})\x1b[0m")
    print(f"  Target: {os.path.basename(target)}")
    print(f"  Emulator: {core}")

    try:
        # Special-case: Wine handled explicitly
        if core == "wine":
            # Maak een unieke Wine prefix per demo
            wine_prefix = os.path.join(
                DOWNLOAD_DIR, f"wine_prefix_{int(time.time())}")
            setup_wine_prefix(wine_prefix)

            # Run in de prefix
            env = os.environ.copy()
            env['WINEPREFIX'] = wine_prefix
            subprocess.run(["wine", target],
                           cwd=os.path.dirname(target), env=env, check=False)

            # Cleanup prefix
            print("\n\x1b[33m🧹 Opschonen Wine prefix...\x1b[0m")
            shutil.rmtree(wine_prefix, ignore_errors=True)
            print("\x1b[32m✓ Prefix verwijderd\x1b[0m")
        elif core == "tic80":
            # Prefer RetroArch core for TIC-80, capture output for debug
            c_path = os.path.join(CORE_DIR, "retro8_libretro.so")
            if os.path.exists(c_path):
                logger.info("Attempting RetroArch TIC-80 core: %s", c_path)
                res = subprocess.run([
                    "retroarch",
                    "-L",
                    c_path,
                    target,
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
                if res.returncode == 0:
                    logger.info("LAUNCH_METHOD=retroarch-core")
                    return
                logger.warning(
                    "RetroArch TIC-80 core failed (rc=%s), stderr: %s",
                    res.returncode,
                    res.stderr.decode('utf-8', errors='ignore'),
                )
            # Fall back to native tic80 if available
            if shutil.which('tic80'):
                logger.info("Falling back to native tic80 binary")
                subprocess.run([
                    "tic80",
                    "--fullscreen",
                    "--surf",
                    target,
                ], capture_output=True, check=False)
            else:
                logger.warning("No tic80 binary found for native fallback")
        else:
            # General path: try RetroArch first (core or auto), then native fallback
            if core and core.endswith('.so'):
                c_path = os.path.join(CORE_DIR, core)
                logger.info(
                    "Attempting RetroArch with core: %s",
                    c_path if os.path.exists(c_path) else core,
                )
                res = subprocess.run([
                    "retroarch",
                    "-L",
                    c_path if os.path.exists(c_path) else core,
                    target,
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
                if res.returncode == 0:
                    logger.info("LAUNCH_METHOD=retroarch-core")
                    return
                logger.warning(
                    "RetroArch core %s failed (rc=%s), stderr: %s",
                    core,
                    res.returncode,
                    res.stderr.decode('utf-8', errors='ignore'),
                )

            # Try RetroArch auto-detect
            logger.info("Attempting RetroArch (auto) for target")
            res = subprocess.run([
                "retroarch",
                target,
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
            if res.returncode == 0:
                logger.info("LAUNCH_METHOD=retroarch-auto")
                return
            logger.warning(
                "RetroArch (auto) failed (rc=%s), stderr: %s",
                res.returncode,
                res.stderr.decode('utf-8', errors='ignore'),
            )

            # Fallback to native emulator binary if present
            if core:
                found = shutil.which(core)
                if found:
                    native_path = found
                    logger.info(
                        "Attempting native fallback: %s (path=%s)",
                        core,
                        native_path,
                    )
                    try:
                        res2 = subprocess.run(
                            [native_path, target],
                            cwd=os.path.dirname(target),
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            check=False,
                        )
                        if res2.returncode == 0:
                            logger.info(
                                "LAUNCH_METHOD=native-fallback %s started %s",
                                core,
                                target,
                            )
                            print("\n\x1b[32m✓ Gestart via native\x1b[0m")
                            return
                        logger.warning(
                            "Native fallback %s failed (rc=%s), stderr: %s",
                            core,
                            res2.returncode,
                            res2.stderr.decode('utf-8', errors='ignore'),
                        )
                    except OSError as e:
                        logger.error(
                            "Native fallback failed to execute: %s",
                            e,
                            exc_info=True,
                        )
            else:
                logger.warning(
                    "No native emulator binary '%s' found for fallback",
                    core,
                )
    except OSError as e:
        print(f"[!] Fout bij opstarten: {e}")


def process(prod_id: Union[str, int]) -> None:
    """Haalt data op, downloadt, pakt uit en start."""
    logger.info("Processing prod: %s", prod_id)
    try:
        data = safe_get_json(
            "https://api.pouet.net/v1/prod/", params={'id': prod_id})
        prod = data.get('prod') if data else None
        if not prod:
            logger.warning("Prod not found: %s", prod_id)
            print("[!] Productie niet gevonden.")
            return

        logger.info("Prod loaded: %s", prod.get('name'))
        download_url = prod.get('download')
        raw_p = prod.get('platforms', [])
        p_iter = cast(Any, raw_p.values()
                      if isinstance(raw_p, dict) else raw_p)
        p_names: List[str] = []
        for p in p_iter:
            if isinstance(p, dict):
                p_dict = cast(Dict[str, Any], p)
                if (name := p_dict.get('name')):
                    p_names.append(str(name))

        # Browser platforms direct afhandelen zonder download
        if any(PLATFORM_MAPPING.get(p) == "browser" for p in p_names):
            logger.info("Browser platform detected: %s", p_names)
            launch(
                None,
                {
                    "name": prod['name'],
                    "p_list": p_names,
                    "url": download_url or f"https://www.pouet.net{prod_id}",
                },
            )
            return

        if not download_url:
            logger.warning("No download URL: %s", prod_id)
            print("[!] Geen download gevonden.")
            return

        shutil.rmtree(EXTRACT_DIR, ignore_errors=True)
        os.makedirs(EXTRACT_DIR, exist_ok=True)

        logger.info("Downloading: %s from %s", prod['name'], download_url)
        print(f"\n\x1b[36m⬇️  Downloading: {prod['name']}...\x1b[0m")
        try:
            # Download using helper which preserves original filename
            file_path = download_file(download_url, prod['name'])

            # Determine extraction strategy
            fname = os.path.basename(file_path).lower()
            logger.debug("Downloaded file path: %s", file_path)

            is_lha = fname.endswith('.lha') or fname.endswith('.lzh')
            is_zip = fname.endswith('.zip')
            is_tar = any(fname.endswith(ext) for ext in (
                '.tar', '.tar.gz', '.tgz', '.tar.bz2', '.tbz'))
            other_archive = any(fname.endswith(ext)
                                for ext in ('.7z', '.rar', '.xz'))

            should_extract = False
            if is_lha:
                should_extract = True
            elif is_zip and zipfile.is_zipfile(file_path):
                should_extract = True
            elif is_tar and tarfile.is_tarfile(file_path):
                should_extract = True
            elif other_archive:
                # We don't have a python-native handler, but attempt 7z
                should_extract = True

            # If we should extract, run the appropriate tool
            if should_extract:
                file_size = os.path.getsize(file_path)
                msg = ("\n\x1b[36m📦 Extracting (" + format_size(file_size) +
                       ")...\x1b[0m")
                print(msg)
                start_time = time.time()

                if is_lha:
                    logger.info("Using LHA extraction")
                    result = subprocess.run(
                        ["lha", f"xw={EXTRACT_DIR}", file_path],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        check=False,
                    )
                    if result.returncode != 0:
                        stderr_msg = result.stderr.decode(
                            'utf-8', errors='ignore')
                        logger.warning("LHA extraction error: %s", stderr_msg)
                        if stderr_msg:
                            first_line = stderr_msg.splitlines()[0]
                        else:
                            first_line = ""
                        print("  ⚠️  LHA warning: " + first_line)
                elif is_zip:
                    try:
                        with zipfile.ZipFile(file_path, 'r') as z:
                            z.extractall(EXTRACT_DIR)
                    except (zipfile.BadZipFile, OSError) as e:
                        logger.warning("zip extraction error: %s", e)
                        print(f"  ⚠️  Zip warning: {e}")
                elif is_tar:
                    try:
                        with tarfile.open(file_path, 'r:*') as t:
                            t.extractall(EXTRACT_DIR)
                    except (tarfile.TarError, OSError) as e:
                        logger.warning("tar extraction error: %s", e)
                        print(f"  ⚠️  Tar warning: {e}")
                else:
                    logger.info("Using 7z extraction")
                    result = subprocess.run(
                        ["7z", "x", file_path, f"-o{EXTRACT_DIR}", "-y"],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        check=False,
                    )
                    if result.returncode != 0:
                        stderr_msg = result.stderr.decode(
                            'utf-8', errors='ignore')
                        logger.warning("7z extraction error: %s", stderr_msg)
                        if stderr_msg:
                            first_line = stderr_msg.splitlines()[0]
                        else:
                            first_line = ""
                        print("  ⚠️  7z warning: " + first_line)

                elapsed = time.time() - start_time
                extracted_files = sum(len(files) for _, _, files in
                                      os.walk(EXTRACT_DIR))
                logger.info("Extraction complete: %d files in %.1fs",
                            extracted_files, elapsed)
                print("  ✓ Extracted %d files (%.1fs)" %
                      (extracted_files, elapsed))

                work_dir = EXTRACT_DIR
            else:
                # Not an archive. Treat file as the target executable/data.
                logger.info("Downloaded file is not an archive, skipping"
                            " extraction: %s", file_path)
                print("\n\x1b[33m⚠️  Niet uitpakken (geen archief)."
                      " Direct starten indien ondersteund.\x1b[0m")
                # Ensure EXTRACT_DIR contains the file for launch logic
                basename = os.path.basename(file_path)
                dest = os.path.join(EXTRACT_DIR, basename)
                try:
                    shutil.copy(file_path, dest)
                except (OSError, IOError) as e:
                    logger.warning(
                        "Could not copy file into EXTRACT_DIR: %s", e)
                    # fallback: use directory containing file
                    dest = file_path

                work_dir = EXTRACT_DIR

            logger.info("Launching application")
            launch(work_dir, {"name": prod['name'], "p_list": p_names})
            # input("\n[Enter] om terug te gaan naar het menu...")

            # Cleanup
            logger.info("Cleaning up downloads")
            print("\n\x1b[33m🧹 Opschonen downloads...\x1b[0m")
            shutil.rmtree(EXTRACT_DIR, ignore_errors=True)
            if os.path.exists(file_path):
                try:
                    os.remove(file_path)
                except (OSError, IOError):
                    logger.warning(
                        "Could not remove downloaded file: %s", file_path)
            print("\x1b[32m✓ Verwijderd\x1b[0m")
            logger.info("Cleanup complete")
        except requests.exceptions.RequestException as e:
            logger.error("Download error: %s", e)
            print(f"[!] Download fout: {e}")
            shutil.rmtree(EXTRACT_DIR, ignore_errors=True)
        except OSError as e:
            logger.error("File system error: %s", e)
            print(f"[!] Bestandssysteem fout: {e}")
            shutil.rmtree(EXTRACT_DIR, ignore_errors=True)
    except (requests.exceptions.RequestException, OSError) as e:
        logger.error("Process error: %s", e, exc_info=True)
        print(f"[!] Verwerkingsfout: {e}")


def display_list(items: List[Any]) -> Optional[Union[int, str]]:
    """Helper om keuzelijsten te tonen."""
    if not items:
        logger.warning("display_list called with empty items")
        print("[!] Niets gevonden.")
        return None

    logger.debug("display_list: %d items", len(items))
    if items and DEBUG:
        logger.debug("First item structure: %s", items[0])

    print("\nResultaten:")
    for i, item in enumerate(items[:25]):
        # Handle both dict and object types
        if isinstance(item, dict):
            item_dict = cast(Dict[str, Any], item)
            name = item_dict.get('name') or item_dict.get('title', 'Onbekend')
            item_id = item_dict.get('id')
        else:
            name = getattr(item, 'name', getattr(item, 'title', 'Onbekend'))
            item_id = getattr(item, 'id', None)

        print(f"{i+1:2}. {name}")
        logger.debug("Item %d: %s (ID: %s)", i + 1, name, item_id)

    sel = input("\nSelecteer een nummer (q=menu): ")
    if sel.isdigit() and 0 < int(sel) <= len(items):
        selected = items[int(sel) - 1]
        if not isinstance(selected, dict):
            return getattr(selected, 'id', None)
        sel_dict = cast(Dict[str, Any], selected)
        return sel_dict.get('id')
    return None

# === MAIN INTERFACE ===


def main():
    base = "https://api.pouet.net/v1"
    while True:
        print("\n" + "="*50)
        print("     POUËT.NET JUKEBOX V0.4-ALPHA (COMPLETE) ")
        print("="*50)
        print("1. Play Prod ID           10. Show Board ID")
        print("2. Random Prod (single)   11. Show List ID")
        print("3. Random Prods (looped)  12. Global Stats")
        print("4. Prod Comments          13. Platforms Enum")
        print("5. Search Prod (q)        14. Front: Latest Added")
        print("6. Search Party (q)       15. Front: Latest Released")
        print("7. Show Party ID          16. Front: All-time Top")
        print("8. Show User ID           17. Front: Top of the Month")
        print("9. Show Group ID")
        print("q. Quit")

        c = input("\nKeuze: ").lower()
        if c in ['q', 'quit', 'exit']:
            break

        if c == "1":
            pid = input("Voer Prod ID in: ")
            if pid.isdigit():
                process(pid)
        elif c == "2":
            res = safe_get_json(f"{base}/prod/", params={'random': 'true'})
            if res and 'prod' in res:
                process(res['prod']['id'])
        elif c == "3":
            count = 0
            try:
                msg = ("[*] Looped random prods gestart. "
                       "Druk Ctrl+C om te stoppen.")
                print(f"\n{msg}")
                while True:
                    url = f"{base}/prod/"
                    res = safe_get_json(url, params={'random': 'true'})
                    if res and 'prod' in res:
                        count += 1
                        logger.info("Looped random prod #%d: %s", count,
                                    res['prod'].get('name'))
                        process(res['prod']['id'])
                    else:
                        print("[!] Kon geen random prod ophalen")
                        break
            except KeyboardInterrupt:
                logger.info("Looped stopped after %d prods", count)
                print(f"\n[*] Looped gestopt na {count} prods.")
        elif c == "4":
            pid = input("Voer Prod ID in voor comments: ")
            data = safe_get_json(f"{base}/prod/comments/", params={'id': pid})
            if data and 'comments' in data:
                for com in data['comments'][:10]:
                    nick = com['user']['nickname']
                    snippet = com['comment'][:200]
                    print("\n[" + nick + "]: " + snippet + "...")
        elif c == "5":
            q = input("Zoekterm Prod: ")
            data = safe_get_json(f"{base}/search/prod/", params={'q': q})
            res = display_list(data.get('prods', []) if data else [])
            if res:
                process(res)
        elif c == "6":
            q = input("Zoekterm Party: ")
            data = safe_get_json(f"{base}/search/party/", params={'q': q})
            res = display_list(data.get('parties', []) if data else [])
            if res:
                p_data = safe_get_json(f"{base}/party/", params={'id': res})
                res_p = display_list(p_data.get('prods', []) if p_data else [])
                if res_p:
                    process(res_p)
        elif c == "7":
            pid = input("Voer Party ID in: ")
            data = safe_get_json(f"{base}/party/", params={'id': pid})
            res = display_list(data.get('prods', []) if data else [])
            if res:
                process(res)
        elif c == "8":
            uid = input("Voer User ID in: ")
            data = safe_get_json(f"{base}/user/", params={'id': uid})
            res = display_list(data.get('prods', []) if data else [])
            if res:
                process(res)
        elif c == "9":
            gid = input("Voer Group ID in: ")
            data = safe_get_json(f"{base}/group/", params={'id': gid})
            res = display_list(data.get('prods', []) if data else [])
            if res:
                process(res)
        elif c == "10":
            bid = input("Voer Board ID in: ")
            data = safe_get_json(f"{base}/board/", params={'id': bid})
            if data and 'board' in data:
                print(f"\nBoard: {data['board']['name']}")
        elif c == "11":
            lid = input("Voer List ID in: ")
            data = safe_get_json(f"{base}/lists/", params={'id': lid})
            res = display_list(data.get('prods', []) if data else [])
            if res:
                process(res)
        elif c == "12":
            if (stats := safe_get_json(f"{base}/stats/")):
                print(f"\nStats: {stats.get('stats')}")
        elif c == "13":
            if (platforms := safe_get_json(f"{base}/enums/platforms/")):
                for pid, info in platforms.get('platforms', {}).items():
                    print(f"ID {pid:3}: {info['name']}")
        elif c in ["14", "15", "16", "17"]:
            paths = {"14": "latest-added", "15": "latest-released",
                     "16": "alltime-top", "17": "top-of-the-month"}
            data = safe_get_json(f"{base}/front-page/{paths[c]}/")
            keys = list(data.keys()) if data else None
            logger.debug("Front-page response keys: %s", keys)
            if data:
                # Try different ways to extract items
                items = None

                # Try to find the first list value in the response
                items = []
                for v in data.values():
                    if isinstance(v, list):
                        items = cast(List[Any], v)
                        break

                # Fallbacks
                if not items:
                    items = data.get('prods', []) or data.get(paths[c], [])

                items_cast = cast(List[Any], items)
                logger.debug(
                    "Extracted %d items",
                    len(items_cast) if items_cast else 0,
                )

                if items_cast:
                    res = display_list(items_cast)
                    if res:
                        process(res)
                else:
                    print("[!] Geen items gevonden in response")
                    logger.warning("Could not extract items from: %s", data)


if __name__ == "__main__":
    os.makedirs(DOWNLOAD_DIR, exist_ok=True)
    os.makedirs(LOG_DIR, exist_ok=True)

    logger.info("%s", "\n" + "*" * 60)
    logger.info("SHOWOUET JUKEBOX STARTED")
    logger.info("%s", "*" * 60)

    log_system_info()
    check_available_tools()

    logger.info("Starting main loop...")
    try:
        main()
    except KeyboardInterrupt:
        logger.info("Interrupted by user")
        print("\n[!] Onderbroken door gebruiker")
    except OSError as e:
        logger.error("Unexpected error in main: %s", e, exc_info=True)
        print(f"[!] Onverwachte fout: {e}")
    finally:
        logger.info("SHOWOUET JUKEBOX STOPPED\n")
