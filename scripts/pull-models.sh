#!/bin/bash
# Pull ALL models for the White Lobster challenge
# Run this AFTER the container is up (Ollama needs to be running)
# Total: ~20GB — be patient

set -e

echo "🦞⚪ Pulling ALL models... this will take a while."
echo ""

# ============================================
# Ollama models
# ============================================

echo "=== Qwen 2.5 ==="
ollama pull qwen2.5:0.5b
ollama pull qwen2.5:1.5b
ollama pull qwen2.5:3b

echo "=== Qwen 2.5 Coder ==="
ollama pull qwen2.5-coder:0.5b
ollama pull qwen2.5-coder:1.5b
ollama pull qwen2.5-coder:3b

echo "=== Qwen 3 ==="
ollama pull qwen3:0.6b
ollama pull qwen3:1.7b
ollama pull qwen3:4b

echo "=== Qwen 3 Vision ==="
ollama pull qwen3-vl:2b
ollama pull qwen3-vl:4b

echo "=== DeepSeek ==="
ollama pull deepseek-r1:1.5b

echo "=== Llama 3.2 ==="
ollama pull llama3.2:1b
ollama pull llama3.2:3b

echo "=== SmolLM2 ==="
ollama pull smollm2:135m
ollama pull smollm2:360m
ollama pull smollm2:1.7b

echo "=== FunctionGemma ==="
ollama pull functiongemma:270m

echo "=== Phase 3: Extra ==="
ollama pull starcoder2:3b
ollama pull codegemma:2b
ollama pull gemma3:1b

# ============================================
# HuggingFace models (GGUF → Ollama import)
# ============================================

echo "=== HuggingFace: Tool Calling Specialists ==="

# eternis Qwen 0.6B tool-calling
mkdir -p /tmp/hf-models
echo "Downloading eternis/qwen-0.6b-tool-calling..."
curl -L -o /tmp/hf-models/eternis-qwen-0.6b-tc.gguf \
  "https://huggingface.co/tensorblock/eternis_eternis_sft_tool_calling_Qwen0.6B_27jul_merged-GGUF/resolve/main/eternis_sft_tool_calling_Qwen0.6B_27jul_merged-Q3_K_M.gguf"

cat > /tmp/hf-models/Modelfile.eternis-tc <<'EOF'
FROM /tmp/hf-models/eternis-qwen-0.6b-tc.gguf
PARAMETER temperature 0.7
PARAMETER num_ctx 4096
SYSTEM You are a tool-calling assistant. When given a task, respond with the appropriate function call.
EOF
ollama create eternis-tc:0.6b -f /tmp/hf-models/Modelfile.eternis-tc

# Manojb Qwen3-4B toolcalling for codex
echo "Downloading Manojb/Qwen3-4B-toolcalling (4.3GB — be patient)..."
curl -L -o /tmp/hf-models/qwen3-4b-tc.gguf \
  "https://huggingface.co/Manojb/Qwen3-4B-toolcalling-gguf-codex/resolve/main/Qwen3-4B-Function-Calling-Pro.gguf"

cat > /tmp/hf-models/Modelfile.qwen3-tc <<'EOF'
FROM /tmp/hf-models/qwen3-4b-tc.gguf
PARAMETER temperature 0.7
PARAMETER num_ctx 4096
SYSTEM You are a tool-calling assistant optimized for code execution tasks.
EOF
ollama create qwen3-tc:4b -f /tmp/hf-models/Modelfile.qwen3-tc

echo ""
echo "========================================="
echo "🦞⚪ All models pulled!"
echo "========================================="
ollama list
echo ""
echo "Cleanup temp files..."
rm -rf /tmp/hf-models
