#!/bin/bash
export VLLM_ATTENTION_BACKEND=FLASHINFER
source .venv/bin/activate
.venv/bin/vllm serve ~/ai/models/qwen3-14b-gptq \
  --served-model-name qwen3-14b-gptq \
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
  --kv-cache-dtype fp8 \
