#!/bin/bash
# Bash-Skript: vLLM-Server für Qwen3-8B mit FP8-Quantisierung

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export VLLM_ATTENTION_BACKEND=FLASHINFER

source .venv/bin/activate

vllm serve ~/ai/models/qwen3-8b-fp8 \
  --served-model-name qwen3-8b-fp8 \
  --trust-remote-code \
  --dtype auto \
  --quantization fp8 \
  --gpu-memory-utilization 0.6 \
  --max-model-len 8192 \
  --max-num-batched-tokens 8192 \
  --max-num-seqs 1 \
  --port 8000 \
  --tool-call-parser hermes \
  --kv-cache-dtype fp8 \
  --disable-log-requests
