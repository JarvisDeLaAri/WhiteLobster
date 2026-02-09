#!/bin/bash
set -e

echo "🦞⚪ White Lobster starting..."

# Start Ollama in background
echo "[1/4] Starting Ollama..."
ollama serve &
sleep 3

# Start Apache
echo "[2/4] Starting Apache..."
service apache2 start

# Start code-server
echo "[3/4] Starting code-server..."
code-server \
  --bind-addr 0.0.0.0:8443 \
  --auth none \
  --disable-telemetry \
  /workspace &

# Initialize LocalGPT if not already done
# Copy workspace files if missing (volume mount hides Dockerfile COPYs on first run)
echo "[4/4] Preparing workspace..."
[ -f /workspace/challenge-prompt.md ] || cp /opt/whitelobster/challenge-prompt.md /workspace/
[ -f /workspace/TOOLS_GUIDE.md ] || cp /opt/whitelobster/TOOLS_GUIDE.md /workspace/
[ -f /root/.localgpt/workspace/MEMORY.md ] || cp /opt/whitelobster/MEMORY.md /root/.localgpt/workspace/

echo ""
echo "========================================="
echo "🦞⚪ White Lobster is ready!"
echo "========================================="
echo "  Ollama API:    http://localhost:11434"
echo "  code-server:   http://localhost:8443"
echo "  Apache:        http://localhost:80"
echo "  LocalGPT:      localgpt chat"
echo "========================================="
echo ""
echo "Run /scripts/pull-models.sh to download models"

# Fix GPU support: install full Ollama with CUDA runners if missing
if [ ! -d /usr/lib/ollama ]; then
  echo "Installing Ollama CUDA runners..."
  curl -fsSL -o /tmp/ollama.tar.zst https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tar.zst
  tar --use-compress-program=unzstd -xf /tmp/ollama.tar.zst -C /usr
  rm -f /tmp/ollama.tar.zst
  echo "✅ Ollama CUDA runners installed"
fi
echo ""

# Keep container alive
tail -f /dev/null
