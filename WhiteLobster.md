# 🦞⚪ White Lobster — The Evil Plan

*Can tiny free models build a TTS web app from scratch?*

---

## The Concept

Build a clean Debian Docker container with LocalGPT + Ollama + tiny models (0.1B–4B parameters). Give them a challenge: install a TTS engine, build a web UI, generate and serve MP3 files. GPU optional (NVIDIA Quadro P2200 available). No cloud APIs. Just local inference and sheer will.

Then make it worse: multi-agent with the tiniest models possible.

---

## Phase 0 — Setup (Do Once)

### Prerequisites
- Docker Desktop installed (Windows/Mac) or Docker Engine (Linux)
- For GPU: NVIDIA drivers installed + Docker Desktop WSL2 backend enabled

### Step 1: Clone
```bash
git clone https://github.com/JarvisDeLaAri/WhiteLobster.git
cd WhiteLobster
```

### Step 2: Build & Start
```bash
# GPU (recommended if you have NVIDIA)
docker compose -f docker-compose.gpu.yml up -d --build

# Or CPU only
docker compose -f docker-compose.cpu.yml up -d --build
```

First build takes ~15-20 min (downloads Rust, compiles LocalGPT, installs code-server).

### Step 3: Pull all models
```bash
docker exec -it white-lobster /scripts/pull-models.sh
```
Downloads ~20GB of models. Go make coffee. ☕

### Step 4: Verify everything works
```bash
# Check Ollama
docker exec white-lobster ollama list

# Check LocalGPT
docker exec white-lobster localgpt config show

# Check Apache
curl http://localhost:8888

# Open code-server in browser
# → http://localhost:8443
```

### Step 5: Start testing!
```bash
# Pick a model (shows list, you choose)
docker exec -it white-lobster /scripts/chaos-mode-single.sh

# Run a step
docker exec -it white-lobster localgpt ask "What is the meaning of life?"

# Clean up between models
docker exec -it white-lobster /scripts/cleanup.sh
```

### Switching Between GPU and CPU
The image is identical — build once, switch freely:
```bash
# Stop current
docker compose -f docker-compose.gpu.yml down

# Start with CPU (same volumes, models already pulled)
docker compose -f docker-compose.cpu.yml up -d
```

### That's It
Everything is scripted. You can be lazy:
- `chaos-mode-single.sh` — shows all models, pick one, it handles the rest
- `cleanup.sh` — wipes everything between tests
- `pull-models.sh` — downloads all 23 models + HF imports
- `entrypoint.sh` — starts all services on container boot

---

## Phase 1 — The Arena (Single Model)

### Setup
- Clean Debian Bookworm Docker container
- Ollama for model serving
- LocalGPT as the agent framework (Rust, ~27MB)
- code-server for monitoring/debugging via browser
- Apache2 for serving the result
- All models pre-pulled

Use `scripts/chaos-mode-single.sh` to pick a model and go.

### The Challenge
Build a Text-to-Speech web application from scratch:
- Install a local TTS engine (piper-tts, espeak-ng, or edge-tts)
- Build a Python backend that accepts text and returns audio
- Build a dark-themed web UI with text input, voice selector, audio player, download
- Configure Apache to serve the frontend and proxy the backend
- Make it actually work and deliver playable MP3/WAV files

### Models to Test (Solo — Each Gets One Shot)

**Qwen 2.5 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| qwen2.5:0.5b | 500M | ~400MB | Basic text, might struggle with code |
| qwen2.5:1.5b | 1.5B | ~1.2GB | Decent reasoning, light code |
| qwen2.5:3b | 3B | ~2.4GB | Solid general purpose |

**Qwen 2.5 Coder:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| qwen2.5-coder:0.5b | 500M | ~400MB | Code-focused but tiny |
| qwen2.5-coder:1.5b | 1.5B | ~1.2GB | Decent code generation |
| qwen2.5-coder:3b | 3B | ~2.4GB | Strong code, the real contender |

**Qwen 3 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| qwen3:0.6b | 600M | ~500MB | Next-gen tiny, improved reasoning |
| qwen3:1.7b | 1.7B | ~1.4GB | Sweet spot for Qwen3 |
| qwen3:4b | 4B | ~3.2GB | Best Qwen3 we can run |

**Qwen 3 Vision:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| qwen3-vl:2b | 2B | ~1.6GB | Can see screenshots of its own work |
| qwen3-vl:4b | 4B | ~3.2GB | Better vision + reasoning |

**Others:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| deepseek-r1:1.5b | 1.5B | ~1.2GB | Reasoning chain (thinks out loud) |
| llama3.2:1b | 1B | ~800MB | Meta's tiny entry |
| llama3.2:3b | 3B | ~2.4GB | Solid Meta baseline |
| smollm2:135m | 135M | ~150MB | The absolute minimum. Can it do anything? |
| smollm2:360m | 360M | ~300MB | Slightly less hopeless |
| smollm2:1.7b | 1.7B | ~1.4GB | SmolLM's best shot |

### Scoring Criteria
- ✅ Did it install a TTS engine correctly?
- ✅ Does the UI render?
- ✅ Can you type text and get audio back?
- ✅ Does the download button work?
- ✅ Does Apache serve it properly?
- ⏱️ How long did it take?
- 🧠 How many retries/corrections needed?
- 🎨 How does the UI look?
- 💀 Did it give up or hallucinate into oblivion?

---

## Phase 2 — The Sub-Agent Nightmare (Multi-Agent)

### The Idea
Instead of one model doing everything, split the work across specialized tiny models via a custom orchestrator script that calls Ollama API directly.

Use `scripts/chaos-mode-multi.sh` to configure the team.

### Architecture
```
ORCHESTRATOR (Main Agent)
├── Plans the project
├── Delegates tasks via @AGENT: <task> format
│
├── TEXT agent
│   └── Writes docs, plans, configs
│
├── TOOLS agent
│   └── Runs shell commands, installs packages
│
└── CODE agent
    └── Writes HTML/CSS/JS/Python
```

### Sub-Agent Concerns
- **functiongemma:270m** — Designed for function calling but "not intended as a direct dialogue model." Single-turn only, needs structured prompts.
- **smollm2:135m as main** — 135 MILLION parameters. GPT-2 was 1.5B and people thought it was tiny. This is 10x smaller. Might just output word salad.
- **Coordination overhead** — The main agent needs to understand what each sub-agent can do and format requests properly. At 135M, that's... ambitious.

---

## Phase 3 — HuggingFace Research (Better Tiny Models)

### 🔧 Tool Calling Specialists (Sub-1B)

Models fine-tuned specifically for function/tool calling at tiny sizes:

| Model | Size | Notes |
|-------|------|-------|
| **eternis/eternis_sft_tool_calling_Qwen0.6B** | 0.6B | Tool-calling fine-tuned Qwen, GGUF available. Active dev (Jul 2025) |
| **eternis/eternis_sft_tool_calling_Qwen1.7B** | 1.7B | Larger version, 4-bit quantized |
| **eternis/eternis_sft_tool_calling_Qwen4B** | 4B | Best of the eternis line |
| **functiongemma:270m** | 270M | Google's official. Single-turn only, structured prompts |
| **rank-and-file/gemma-3-1b-it-tool-calling** | 1B | Gemma 3 fine-tuned for tools |
| **Llama_3.2_1B_Instruct_Tool_Calling_V2** | 1B | 116 downloads, Llama-based |
| **codelion/Llama-3.2-1B-Instruct-tool-calling-lora** | 1B | LoRA adapter, 126 downloads |
| **Manojb/Qwen3-4B-toolcalling-gguf-codex** | 4B | 2K+ downloads, 47 likes — **popular pick** for Codex/Claude Code style |

**Best bet:** eternis Qwen 0.6B — purpose-built, multi-turn unlike functiongemma.

### 💻 Code Specialists (Sub-4B)

| Model | Size | Notes |
|-------|------|-------|
| **qwen2.5-coder:0.5b** | 0.5B | Decent for simple scripts |
| **qwen2.5-coder:1.5b** | 1.5B | Sweet spot — much better quality |
| **qwen2.5-coder:3b** | 3B | Best code quality in our range |
| **deepseek-coder-v2-lite** | 2.4B | DeepSeek's code model, MoE architecture |
| **starcoder2:3b** | 3B | BigCode's latest, good at completions |
| **stable-code:3b** | 3B | Stability AI's code model |
| **codegemma:2b** | 2B | Google's code model, good at infilling |

**Best bet:** qwen2.5-coder:1.5b — Ollama-native, 3x the 0.5B, big quality jump.

### 🧠 Orchestrator / Instruction Following (Sub-1B)

Hardest role — needs to understand tasks, break into steps, delegate, handle failures.

| Model | Size | Notes |
|-------|------|-------|
| **smollm2:135m** | 135M | Probably too small for orchestration |
| **smollm2:360m** | 360M | 2.5x bigger, might manage |
| **qwen3:0.6b** | 0.6B | Qwen3 improved reasoning significantly at small sizes |
| **phi-1.5** | 1.3B | Microsoft's "textbooks are all you need". Strong reasoning for size |
| **tinyllama:1.1b** | 1.1B | Well-known tiny, decent instruction following |
| **gemma-3:1b** | 1B | Google's latest tiny, good structured output |

**Best bet:** qwen3:0.6b — notably better reasoning than Qwen2.5 at same size.

---

## ⚡ Jarvis Recommends

### 🏆 Solo Challenge (Phase 1)
**qwen2.5-coder:3b** — Best shot at actually completing the TTS challenge solo.

### 🧠 Serious Multi-Agent Team (Phase 2)
```
MAIN:  qwen3:0.6b          (~500MB)  — best tiny orchestrator
├── TEXT:   smollm2:360m    (~300MB)  — cheapest, text-only tasks
├── TOOLS:  eternis-tc:0.6b (~500MB)  — purpose-built tool calling
└── CODE:   qwen2.5-coder:1.5b (~1.2GB) — sweet spot coder

TOTAL: ~2.5GB (sequential loading)
```

### 💀 Chaos Mode (The True Evil)
```
MAIN:  smollm2:135m         (~150MB)  — the toddler manager
├── TEXT:   smollm2:135m     (~150MB)  — same toddler, different hat
├── TOOLS:  functiongemma:270m (~250MB) — single-turn, structured
└── CODE:   qwen2.5-coder:0.5b (~400MB) — smallest code model

TOTAL: ~0.95GB
```

*Run both. Compare. Laugh.*

---

## Port Allocation
| Service | Port |
|---------|------|
| Ollama API | 11434 |
| LocalGPT daemon | 8585 |
| code-server (VS Code) | 8443 |
| The TTS App (Apache) | 8888 |

## Resource Estimates
- **Disk:** ~20GB (Debian base + Ollama + all models + HF imports + tools)
- **RAM:** 4-8GB recommended (largest model is 4B @ ~3.2GB + overhead)
- **GPU:** NVIDIA Quadro P2200 (5GB VRAM) — optional, use `docker-compose.gpu.yml`
- **CPU-only:** Use `docker-compose.cpu.yml` — slower but works anywhere

## Files in This Project
| File | What |
|------|------|
| `WhiteLobster.md` | This file — master plan |
| `challenge-prompt.md` | The 10-step progressive exam |
| `Dockerfile` | Container image definition |
| `docker-compose.gpu.yml` | Docker Compose with NVIDIA GPU |
| `docker-compose.cpu.yml` | Docker Compose CPU-only |
| `localgpt-config.toml` | LocalGPT config template |
| `scripts/` | All shell scripts: |
| `scripts/chaos-mode-single.sh` | Phase 1: pick one model |
| `scripts/chaos-mode-multi.sh` | Phase 2: configure agent team |
| `scripts/pull-models.sh` | Download all models (Ollama + HuggingFace) |
| `scripts/entrypoint.sh` | Container startup script |
| `scripts/cleanup.sh` | Wipe between model tests |
| `scripts/orchestrator.py` | Phase 2: multi-agent orchestration loop |
| `scoreboard/` | Ranking dashboard (port 10007) |
