#!/bin/bash
# CHECK NVIDIA VERSION WITH NVIDIA-SMI I HAVE 12.7 BUT IF YOU HAVE 12.8 UV pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu12 or uv pip install torch==2.6.0 torchaudio --index-url https://download.pytorch.org/whl/nightly/cu130

curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
curl -sSL https://astral.sh/uv/install.sh -o install-uv.sh
python3 get-pip.py
bash install-uv.sh

pip install --upgrade pip uv nltk 
uv pip install torch==2.6.0 torchaudio --index-url https://download.pytorch.org/whl/cu126
uv pip install -r extra-req.txt --no-deps
uv pip install -r requirements.txt

python - <<PYCODE
import nltk
for pkg in ["averaged_perceptron_tagger", "cmudict"]:
    nltk.download(pkg)
PYCODE
