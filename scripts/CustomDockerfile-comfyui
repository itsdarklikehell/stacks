FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git && \
    apt --fix-broken install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ROOT=/stable-diffusion

WORKDIR /stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
    git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
    cd ${ROOT} && \
    # git checkout master && \
    pip install -r requirements.txt

WORKDIR /stable-diffusion/custom_nodes
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && \
    # git checkout master && \
    pip install -r requirements.txt

WORKDIR ${ROOT}
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

ENV NVIDIA_VISIBLE_DEVICES=all
ENV PYTHONPATH="${PYTHONPATH}:${PWD}"
ENV CLI_ARGS="--listen 0.0.0.0 --port 7860"

EXPOSE 7860

ENTRYPOINT ["/docker/entrypoint.sh"]

# CMD ["python", "-u", "main.py", "--listen", "--port", "7860", "${CLI_ARGS}"]
CMD ["python", "-u", "main.py", "--listen", "0.0.0.0", "--port", "7860"]