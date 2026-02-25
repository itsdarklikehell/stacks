# 🎹 Ultimate AI Sample Sorter for PicoTracker

A complete AI-driven pipeline that takes ANY media file and turns it into a perfectly organized 16-bit Mono WAV library.

## 🛠 Features

- **Video Extraction**: Grabs audio from `.mp4`, `.mov`, `.avi`, etc.
- **SoundFont Unpacking**: Extracts individual samples from `.sf2` files.
- **AI Intelligence**: Uses **Essentia** for tech-data and **Ollama** for human-like categorization.
- **Auto-Format**: Forces everything to **16-bit / 44.1kHz / Mono WAV**.

## 🚀 Quick Start

1. Edit `docker-compose.yml` to map your folders.
2. Set `DRY_RUN=True` for a test run.
3. Run: `docker-compose up -d --build pico_sorter`.

## 📂 Supported Formats

Audio, Video, SF2, and more. _Note: MIDI is skipped as it contains no audio data._
