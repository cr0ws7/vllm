#!/bin/bash
export PYTORCH_CUDA_ALLOC_CONF="garbage_collection_threshold:0.6,max_split_size_mb:128,expandable_segments:True"
export VLLM_ATTENTION_BACKEND=FLASHINFER
source .venv/bin/activate
.venv/bin/vllm serve ~/ai/models/qwen3-14b-gptq \
  --served-model-name qwen3-14b-gptq \
  --trust-remote-code \
  --dtype auto \
  --gpu-memory-utilization 0.74 \
  --max-model-len 8000 \
  --max-num-batched-tokens 8000 \
  --max-num-seqs 1 \
  --port 8000 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes \
  --reasoning-parser deepseek_r1 \
  --kv-cache-dtype fp8 \
  --enforce-eager \
