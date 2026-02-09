# Troubleshoot: Ollama Not Using GPU

## Symptoms
- `ollama ps` shows `100% CPU`
- `nvidia-smi` works inside container (GPU visible) but Ollama ignores it
- Logs show `total_vram="0 B"` and `offloaded 0/29 layers to GPU`

## Root Cause
The Dockerfile installs the Ollama binary to `/usr/local/bin/ollama` but extracts CUDA runner libraries to `/usr/lib/ollama/`. Ollama looks for its libraries **relative to its own binary path** — so it searches `/usr/local/lib/ollama/` which doesn't exist.

## Fix

### Option A: Symlink (quick)
```bash
ln -s /usr/lib/ollama /usr/local/lib/ollama
pkill -9 ollama
sleep 2
hash -r
ollama serve &
sleep 3
ollama run qwen3:0.6b "hi" --verbose
```

### Option B: Move binary (permanent)
```bash
mv /usr/local/bin/ollama /usr/bin/ollama
pkill -9 ollama
sleep 2
hash -r
ollama serve &
sleep 3
ollama run qwen3:0.6b "hi" --verbose
```

## Verify It Worked
Look for these lines in the output:
```
ggml_cuda_init: found 1 CUDA devices:
  Device 0: Quadro P2200, compute capability 6.1
offloaded 29/29 layers to GPU
```

And check:
```bash
ollama ps
```
Should show `100% GPU` instead of `100% CPU`.

## Before vs After
| Metric | CPU | GPU |
|--------|-----|-----|
| eval rate (qwen3:0.6b) | ~14 tokens/s | ~89 tokens/s |
| prompt eval rate | ~24 tokens/s | ~363 tokens/s |
| speedup | — | **~6x faster** |

## Prevention
The entrypoint.sh and Dockerfile have been updated to install the full Ollama tarball (including CUDA runners). For existing containers, apply one of the fixes above.
