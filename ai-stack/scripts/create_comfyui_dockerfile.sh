#!/bin/bash
# Create ComfyUI Dockerfile
function CREATE_COMFYUI_DOCKERFILE(){
cat << EOF > "${WD}/stable-diffusion-webui-docker/services/comfy/Dockerfile"
FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime
ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1
RUN apt update && apt install -y git && apt clean
ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone --recursive https://github.com/comfyanonymous/ComfyUI.git /stable-diffusion && \
  pip install -r /stable-diffusion/requirements.txt && \
  git clone --recursive https://github.com/Comfy-Org/ComfyUI-Manager.git /stable-diffusion/custom_nodes/ComfyUI-Manager && \
  pip install -r /stable-diffusion/custom_nodes/ComfyUI-Manager/requirements.txt
WORKDIR /stable-diffusion
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml /stable-diffusion
ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
EOF
}
CREATE_COMFYUI_DOCKERFILE 