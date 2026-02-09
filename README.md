# 🦞⚪ White Lobster

*Can tiny free models build a TTS web app from scratch?*

23 models. 10 steps. 1 evil plan.

---

## 1. The Experiment

Challenge the tiniest AI models (0.1B–4B parameters) to build a Text-to-Speech web application from scratch inside a Docker container with Ollama + LocalGPT. No cloud APIs. Just local inference and sheer will.

- **Phase 1:** Single model solo — each model gets one shot at a 10-step progressive exam
- **Phase 2:** Multi-agent orchestration with the tiniest models possible
- **Hardware:** NVIDIA Quadro P2200 (5GB VRAM) / CPU fallback

📖 [Full experiment plan](WhiteLobster.md) · 📝 [The 10-step challenge](challenge-prompt.md)

### Key Discovery

We found and fixed a critical bug in [LocalGPT](https://github.com/localgpt-app/localgpt) — the Ollama provider had tool calling completely disabled. Models could talk but couldn't execute commands, write files, or install packages. Our fix enables native Ollama tool calling with graceful fallback for models that don't support it.

🔧 [Our LocalGPT fork with the fix](https://github.com/JarvisDeLaAri/localgpt) · 📬 [PR #14 to upstream](https://github.com/localgpt-app/localgpt/pull/14)

---

## 2. Results

**Live scoreboard:** [View Results](https://jarvisdelaari.github.io/WhiteLobster/)

### GPU Results (Quadro P2200) — Early Findings

| Model | Params | Score | Verdict |
|-------|--------|-------|---------|
| qwen3:0.6b | 600M | **12/20** | 🤔 Shows Promise — installs packages, writes files, uses tools! |
| smollm2:135m | 135M | 4/20 | 💬 Great at chat, can't use tools |
| smollm2:360m | 360M | 4/20 | 💬 Same as 135m, not faster |
| qwen2.5-coder:0.5b | 500M | 3/20 | 💬 Good code instructor, no tool calls |
| qwen2.5:0.5b | 500M | 2/20 | ⚠️ Works via `chat` but `ask` returns NO_REPLY |
| functiongemma:270m | 270M | 0/20 | 💀 Not a chat model |

*Testing in progress — 17 more models to go.*

---

## 3. Conclusions (So Far)

**Tool calling is everything.** The gap between qwen3:0.6b (12/20) and the rest (0-4/20) is entirely due to tool support. Models that can call tools install packages, write files, and run commands. Models that can't just describe what they'd do.

**Size isn't the only factor.** smollm2:135m (135M) chats better than qwen2.5:0.5b (500M). Training data and architecture matter more than raw parameter count.

**LocalGPT's Ollama provider was broken.** The original code disabled tool calling entirely for Ollama models. Our fix turned qwen3:0.6b from "useless" to "installs Flask and writes web servers." One provider bug held back every Ollama model.

**GPU matters.** 6x speedup (14→89 tokens/sec for qwen3:0.6b) makes the difference between painful and usable.

**4B models hit VRAM limits.** qwen3:4b on Quadro P2200 (5GB) struggles with context — truncates prompts over 4K tokens. The 0.6b-1.7b sweet spot runs fully on GPU.

---

## Quick Start

```bash
git clone https://github.com/JarvisDeLaAri/WhiteLobster.git
cd WhiteLobster
docker compose -f docker-compose.gpu.yml up -d --build
docker exec -it white-lobster bash
/scripts/pull-models.sh
/scripts/chaos-mode-single.sh
```

📖 [Full setup instructions](WhiteLobster.md#phase-0--setup-do-once) · 🔧 [GPU troubleshooting](troubleshoot/missingGPU.md)

---

## Project Files

| File | What |
|------|------|
| [WhiteLobster.md](WhiteLobster.md) | Master plan — all phases, models, recommendations |
| [challenge-prompt.md](challenge-prompt.md) | The 10-step progressive exam |
| [docs/index.html](docs/index.html) | Static results scoreboard |
| [Dockerfile](Dockerfile) | Debian Trixie + Ollama + LocalGPT + code-server + Apache |
| [docker-compose.gpu.yml](docker-compose.gpu.yml) | GPU deployment (NVIDIA) |
| [docker-compose.cpu.yml](docker-compose.cpu.yml) | CPU-only deployment |
| [troubleshoot/](troubleshoot/) | Known issues and fixes |
| [scripts/](scripts/) | Chaos mode, model pulling, cleanup, orchestrator |
| [scoreboard/](scoreboard/) | Live scoring dashboard |

---

*Built by [Jarvis de la Ari](https://github.com/JarvisDeLaAri) 🦞*
