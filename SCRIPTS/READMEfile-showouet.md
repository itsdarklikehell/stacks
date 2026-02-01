# 📺 Showouet Jukebox

Showouet is een interactieve demoscene jukebox voor [Pouet.net](https://www.pouet.net). Het script downloadt automatisch demo's, pakt ze uit en start de juiste emulator (Wine, DOSBox of RetroArch).

## 🚀 Features
- **Multi-platform support**: Draait in Docker, lokale Python omgevingen of venv.
- **Auto-emulatie**: Kiest automatisch tussen Wine (Windows), DOSBox (DOS) of RetroArch (Amiga, C64, etc.).
- **Multi-disk support**: Genereert automatisch M3U playlists voor demo's met meerdere disks.
- **Favorieten**: Sla je favoriete demo's op in een lokale collectie inclusief platform-metadata.
- **Nvidia GPU versnelling**: Volledige ondersteuning voor Nvidia-runtime in Docker.

---

## 🐳 Gebruik in Docker (Aanbevolen)

Gebruik de meegeleverde `compose.yaml` en `Dockerfile`.

1. **Bouw en start de container**:
   ```bash
   docker compose up -d --build

