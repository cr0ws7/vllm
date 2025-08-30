# Base image with CUDA & PyTorch. If your system uses a different CUDA version,
# change this tag to match your host's CUDA or use a CPU base image.
FROM pytorch/pytorch:2.2.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV VLLM_ATTENTION_BACKEND=FLASHINFER

WORKDIR /app

# Copy repo into image
COPY . /app

# Install system dependencies required to build/install vllm and some common
# extras (ffmpeg is useful for some model tooling). Keep layers minimal.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential cmake git ninja-build libomp-dev ffmpeg python3-dev \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python build/runtime requirements. The project uses
# an editable install so local changes are available inside the container.
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir cmake ninja packaging jinja2 regex \
 && pip install --no-cache-dir -e .

# Expose the default vllm port used in your launch script
EXPOSE 8000

# Default command. It uses environment variables so you can override model path
# and served model name at runtime via docker run -e MODEL_PATH=... etc.
CMD ["bash", "-lc", "vllm serve /models/${MODEL_PATH:-qwen3-14b-gptq} \
  --served-model-name ${SERVED_MODEL_NAME:-qwen3-14b-gptq} \
  --trust-remote-code \
  --dtype auto \
  --gpu-memory-utilization 0.71 \
  --max-model-len 5000 \
  --max-num-batched-tokens 5000 \
  --max-num-seqs 1 \
  --port 8000 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes \
  --reasoning-parser deepseek_r1 \
  --kv-cache-dtype fp8"]
