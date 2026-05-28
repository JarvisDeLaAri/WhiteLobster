# 🦞⚪ White Lobster V2 — The White-Snake Plan

*Can tiny free models build a Snake with pure html/css/js from scratch?*

---

## The Concept

Test the tinyest models with some tasks up to create snake game and compare to some top tier model, just for the fun of it, and learn their real limits.

Unlike V1 (see [docs/V1](https://github.com/JarvisDeLaAri/WhiteLobster/blob/main/docs/V1)) where i tried to use `localGPT` in a docker to learn both, this time i will just use PI coding agent. (V1 had some more serious dreams in mind lol)


---

## Phase 0 — Setup (Do Once)

1. install pi coding agent
2. install ollama
3. pull relevant models local and cloud (running on laptop with crap gpu)
4. my final tests will be with claude and its 3 top tier models

---

## Phase 1 — The Arena (Single Model)

I have OpenClaw installed on this laptop and i will ask it to:

1. read list of models
2. create folder for each one under `/results/V2`
3. for each model run `pi -p` and demand results (if relevant) to html file
4. create `docs/V2/index.html` with score board, AI will mark binary tasks, i will test the snake game and score it.

### Models to Test (Solo — Each Gets One Shot)

**Granite 4.1 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| granite4.1:3b | 3B | ~2.4GB | IBM code-focused, solid reasoning |
| granite4.1:8b | 8B | ~6.4GB | Best Granite we can run |

**Gemma 4 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| gemma4:e2b | 2B | ~1.6GB | Google's tiny entry, efficient |
| gemma4:e4b | 4B | ~3.2GB | Sweet spot for Gemma4 |

**Qwen 3.5 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| qwen3.5:0.8b | 0.8B | ~640MB | Next-gen tiny, improved reasoning |
| qwen3.5:2b | 2B | ~1.6GB | Sweet spot for Qwen3.5 |
| qwen3.5:4b | 4B | ~3.2GB | Balanced performance |
| qwen3.5:9b | 9B | ~7.2GB | Best Qwen3.5 we can run |

**DeepSeek R1 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| deepseek-r1:1.5b | 1.5B | ~1.2GB | Reasoning chain (thinks out loud) |
| deepseek-r1:7b | 7B | ~5.6GB | Solid reasoning baseline |
| deepseek-r1:8b | 8B | ~6.4GB | Strong reasoning performer |
| deepseek-r1:14b | 14B | ~11.2GB | Best R1 we can run |

**Falcon 3 Family:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| falcon3:1b | 1B | ~800MB | TII's tiny entry |
| falcon3:3b | 3B | ~2.4GB | Solid Falcon baseline |
| falcon3:7b | 7B | ~5.6GB | Strong general purpose |
| falcon3:10b | 10B | ~8.0GB | Best Falcon3 we can run |

**Others:**
| Model | Params | RAM Est. | Good At |
|-------|--------|----------|---------|
| smollm2:1.7b | 1.7B | ~1.4GB | Lightweight general purpose |
| nemotron-3-nano:4b | 4B | ~3.2GB | NVIDIA's compact model |
| rnj-1:8b | 8B | ~6.4GB | General purpose mid-size |
