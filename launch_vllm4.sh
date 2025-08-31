#!/bin/bash
# Bash-Skript: vLLM-Server für Qwen3-8B mit FP8-Quantisierung

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export VLLM_ATTENTION_BACKEND=FLASHINFER

source .venv/bin/activate

vllm serve ~/ai/models/qwen3-4b-instruct-2507 \
  --served-model-name qwen3-4b-instruct-2507 \
  --trust-remote-code \
  --dtype auto \
  --gpu-memory-utilization 0.7 \
  --max-model-len 12000 \
  --max-num-batched-tokens 12000 \
  --max-num-seqs 1 \
  --port 8000 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes \
  --kv-cache-dtype fp8 \
  --disable-log-requests