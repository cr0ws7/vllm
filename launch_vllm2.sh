#!/bin/bash
export VLLM_ATTENTION_BACKEND=FLASHINFER

 # CUDA memory allocation expandable -> reduce fragmentation
 export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

source .venv/bin/activate
.venv/bin/vllm serve ~/ai/models/hunyuan-a13b-gptq-int4 \
  --served-model-name hunyuan-a13b-gptq-int4 \
  --trust-remote-code \
  --dtype auto \
  --quantization gptq_marlin \
  --gpu-memory-utilization 0.55 \
  --max-model-len 10000 \
  --max-num-batched-tokens 10000 \
  --max-num-seqs 1 \
  --port 8000 \
  --tool-call-parser hunyuan_a13b \
  --kv-cache-dtype fp8 \
  --disable-log-requests \
  --enable-auto-tool-choice