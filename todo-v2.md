# White Lobster V2 — Full Test TODO

*19 models × 9 tasks = 171 total tasks. Sequential on Quadro P2200 (5GB VRAM).*

---

## Task Breakdown (9 per model)

| # | Task | Subagent | Notes |
|---|------|----------|-------|
| 1 | **Pull** `ollama pull <model>` | Independent | Download model to Ollama |
| 2 | **S1** Chat test | Independent | blockedBy Task 1 |
| 3 | **S2** Instruction following | Independent | blockedBy Task 2 |
| 4 | **S3** Write file | Independent | blockedBy Task 3, needs `--tools read,bash` |
| 5 | **S4** Run file | Independent | blockedBy Task 4 |
| 6 | **S5** Web server | Independent | blockedBy Task 5, needs `--tools read,bash` |
| 7 | **S6** API | Independent | blockedBy Task 6, needs `--tools read,bash` |
| 8 | **S7** Snake game | Independent | blockedBy Task 7, needs `--tools read,bash` |
| 9 | **RM** `ollama rm <model>` | Independent | blockedBy Task 8 |

---

## The 7 Steps (per `challenge-prompt.md`)

| Step | Prompt | Score |
|------|--------|-------|
| S1 | "What is the meaning of life?" | 0/1/2 |
| S2 | "List exactly 5 fruits. Number them 1-5. Nothing else." | 0/1/2 |
| S3 | Write `03-hello.js` to `/results/V2/<model>/` | 0/1/2 |
| S4 | Run `node /results/V2/<model>/03-hello.js` | 0/1/2 |
| S5 | Write `05-web-server.js`, run on port 5000, `curl localhost:5000` | 0/1/2 |
| S6 | Write `06-api.js`, POST /api/echo on port 5001, test with curl | 0/1/2 |
| S7 | Write `07-snake.html` — pure HTML5/CSS3/JS vanilla snake game | 0/1/2 (human scored) |

**Total: /14**

---

## Models (in order: smallest → largest)

### Model 1: qwen3.5:0.8b (0.8B, 32K ctx) — **IN PROGRESS** Score: 6/14 so far (S1=2, S2=2, S3=2)
- [x] Task 1.1: Pull qwen3.5:0.8b
- [x] Task 1.2: S1 — Chat test (score: 2)
- [x] Task 1.3: S2 — Instruction following (score: 2)
- [x] Task 1.4: S3 — Write 03-hello.js (score: 2)
- [x] Task 1.5: S4 — Run 03-hello.js (skipped)
- [x] Task 1.6: S5 — Web server on port 5000 (skipped)
- [x] Task 1.7: S6 — API on port 5001 (skipped)
- [x] Task 1.8: S7 — Snake game (skipped)
- [x] Task 1.9: RM qwen3.5:0.8b

### Model 2: falcon3:1b (1B, 32K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 2.1: Pull falcon3:1b
- [x] Task 2.2: S1 (score: 2)
- [x] Task 2.3: S2 (score: 2)
- [x] Task 2.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 2.5: S4 (skipped)
- [x] Task 2.6: S5 (skipped)
- [x] Task 2.7: S6 (skipped)
- [x] Task 2.8: S7 (skipped)
- [x] Task 2.9: RM falcon3:1b

### Model 3: deepseek-r1:1.5b (1.5B, 128K ctx) — **DONE** Score: 2/14 (S1=1, S2=1, S3=0, S4-S7=skipped)
- [x] Task 3.1: Pull deepseek-r1:1.5b
- [x] Task 3.2: S1 (score: 1)
- [x] Task 3.3: S2 (score: 1)
- [x] Task 3.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 3.5: S4 (skipped)
- [x] Task 3.6: S5 (skipped)
- [x] Task 3.7: S6 (skipped)
- [x] Task 3.8: S7 (skipped)
- [x] Task 3.9: RM deepseek-r1:1.5b

### Model 4: smollm2:1.7b (1.7B, 2K ctx) — **DONE** Score: 1/14 (S1=1, S2=0, S3-S7=skipped)
- [x] Task 4.1: Pull smollm2:1.7b
- [x] Task 4.2: S1 (score: 1)
- [x] Task 4.3: S2 (score: 0 — **ABORTED**, model can't follow instructions via pi)
- [x] Task 4.4: S3 (skipped)
- [x] Task 4.5: S4 (skipped)
- [x] Task 4.6: S5 (skipped)
- [x] Task 4.7: S6 (skipped)
- [x] Task 4.8: S7 (skipped)
- [x] Task 4.9: RM smollm2:1.7b

### Model 5: gemma4:e2b (2B, 128K ctx) — **DONE** Score: 0/14 (S1=0, S2-S7=skipped)
- [x] Task 5.1: Pull gemma4:e2b
- [x] Task 5.2: S1 (score: 0 — **ABORTED**, gibberish output)
- [x] Task 5.3: S2 (skipped)
- [x] Task 5.4: S3 (skipped)
- [x] Task 5.5: S4 (skipped)
- [x] Task 5.6: S5 (skipped)
- [x] Task 5.7: S6 (skipped)
- [x] Task 5.8: S7 (skipped)
- [x] Task 5.9: RM gemma4:e2b

### Model 6: qwen3.5:2b (2B, 32K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 6.1: Pull qwen3.5:2b
- [x] Task 6.2: S1 (score: 2)
- [x] Task 6.3: S2 (score: 2)
- [x] Task 6.4: S3 (score: 0 — **ABORTED**, pi stuck in tool loop)
- [x] Task 6.5: S4 (skipped)
- [x] Task 6.6: S5 (skipped)
- [x] Task 6.7: S6 (skipped)
- [x] Task 6.8: S7 (skipped)
- [x] Task 6.9: RM qwen3.5:2b

### Model 7: granite4.1:3b (3B, 128K ctx) — **DONE** Score: 0/14 (S1=0, S2-S7=skipped)
- [x] Task 7.1: Pull granite4.1:3b
- [x] Task 7.2: S1 (score: 0 — **ABORTED**, pi can't find model in provider)
- [x] Task 7.3: S2 (skipped)
- [x] Task 7.4: S3 (skipped)
- [x] Task 7.5: S4 (skipped)
- [x] Task 7.6: S5 (skipped)
- [x] Task 7.7: S6 (skipped)
- [x] Task 7.8: S7 (skipped)
- [x] Task 7.9: RM granite4.1:3b

### Model 8: falcon3:3b (3B, 32K ctx) — **DONE** Score: 2/14 (S1=2, S2=0, S3-S7=skipped)
- [x] Task 8.1: Pull falcon3:3b
- [x] Task 8.2: S1 (score: 2)
- [x] Task 8.3: S2 (score: 0 — **ABORTED**, pi fails with "does not support tools")
- [x] Task 8.4: S3 (skipped)
- [x] Task 8.5: S4 (skipped)
- [x] Task 8.6: S5 (skipped)
- [x] Task 8.7: S6 (skipped)
- [x] Task 8.8: S7 (skipped)
- [x] Task 8.9: RM falcon3:3b

### Model 9: gemma4:e4b (4B, 128K ctx) — **DONE** Score: 1/14 (S1=1, S2=0, S3-S7=skipped)
- [x] Task 9.1: Pull gemma4:e4b
- [x] Task 9.2: S1 (score: 1)
- [x] Task 9.3: S2 (score: 0 — **ABORTED**, gibberish output)
- [x] Task 9.4: S3 (skipped)
- [x] Task 9.5: S4 (skipped)
- [x] Task 9.6: S5 (skipped)
- [x] Task 9.7: S6 (skipped)
- [x] Task 9.8: S7 (skipped)
- [x] Task 9.9: RM gemma4:e4b

### Model 10: qwen3.5:4b (4B, 32K ctx) — **DONE** Score: 12/14 (S1=2, S2=2, S3=2, S4=2, S5=2, S6=2, S7=0)
- [x] Task 10.1: Pull qwen3.5:4b
- [x] Task 10.2: S1 (score: 2)
- [x] Task 10.3: S2 (score: 2)
- [x] Task 10.4: S3 (score: 2)
- [x] Task 10.5: S4 (score: 2)
- [x] Task 10.6: S5 (score: 2)
- [x] Task 10.7: S6 (score: 2)
- [x] Task 10.8: S7 (score: 0 — pi hung, no snake file created)
- [x] Task 10.9: RM qwen3.5:4b

### Model 11: nemotron-3-nano:4b (4B, 262K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 11.1: Pull nemotron-3-nano:4b
- [x] Task 11.2: S1 (score: 2)
- [x] Task 11.3: S2 (score: 2)
- [x] Task 11.4: S3 (score: 0 — **ABORTED**, model can't write files via pi)
- [x] Task 11.5: S4 (skipped)
- [x] Task 11.6: S5 (skipped)
- [x] Task 11.7: S6 (skipped)
- [x] Task 11.8: S7 (skipped)
- [x] Task 11.9: RM nemotron-3-nano:4b

### Model 12: deepseek-r1:7b (7B, 128K ctx) — **DONE** Score: 3/14 (S1=1, S2=2, S3=0, S4-S7=skipped)
- [x] Task 12.1: Pull deepseek-r1:7b
- [x] Task 12.2: S1 (score: 1)
- [x] Task 12.3: S2 (score: 2)
- [x] Task 12.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 12.5: S4 (skipped)
- [x] Task 12.6: S5 (skipped)
- [x] Task 12.7: S6 (skipped)
- [x] Task 12.8: S7 (skipped)
- [x] Task 12.9: RM deepseek-r1:7b

### Model 13: falcon3:7b (7B, 32K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 13.1: Pull falcon3:7b
- [x] Task 13.2: S1 (score: 2)
- [x] Task 13.3: S2 (score: 2)
- [x] Task 13.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 13.5: S4 (skipped)
- [x] Task 13.6: S5 (skipped)
- [x] Task 13.7: S6 (skipped)
- [x] Task 13.8: S7 (skipped)
- [x] Task 13.9: RM falcon3:7b

### Model 14: granite4.1:8b (8B, 128K ctx) — **DONE** Score: 3/14 (S1=2, S2=1, S3=0, S4-S7=skipped)
- [x] Task 14.1: Pull granite4.1:8b
- [x] Task 14.2: S1 (score: 2)
- [x] Task 14.3: S2 (score: 1)
- [x] Task 14.4: S3 (score: 0 — **ABORTED**, pi can't write files)
- [x] Task 14.5: S4 (skipped)
- [x] Task 14.6: S5 (skipped)
- [x] Task 14.7: S6 (skipped)
- [x] Task 14.8: S7 (skipped)
- [x] Task 14.9: RM granite4.1:8b

### Model 15: deepseek-r1:8b (8B, 128K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 15.1: Pull deepseek-r1:8b
- [x] Task 15.2: S1 (score: 2)
- [x] Task 15.3: S2 (score: 2)
- [x] Task 15.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 15.5: S4 (skipped)
- [x] Task 15.6: S5 (skipped)
- [x] Task 15.7: S6 (skipped)
- [x] Task 15.8: S7 (skipped)
- [x] Task 15.9: RM deepseek-r1:8b

### Model 16: rnj-1:8b (8B, 32K ctx) — **DONE** Score: 3/14 (S1=1, S2=2, S3=0, S4-S7=skipped)
- [x] Task 16.1: Pull rnj-1:8b
- [x] Task 16.2: S1 (score: 1)
- [x] Task 16.3: S2 (score: 2)
- [x] Task 16.4: S3 (score: 0 — **ABORTED**, gibberish output)
- [x] Task 16.5: S4 (skipped)
- [x] Task 16.6: S5 (skipped)
- [x] Task 16.7: S6 (skipped)
- [x] Task 16.8: S7 (skipped)
- [x] Task 16.9: RM rnj-1:8b

### Model 17: qwen3.5:9b (9B, 32K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 17.1: Pull qwen3.5:9b
- [x] Task 17.2: S1 (score: 2)
- [x] Task 17.3: S2 (score: 2)
- [x] Task 17.4: S3 (score: 0 — **ABORTED**, pi hung in tool loop)
- [x] Task 17.5: S4 (skipped)
- [x] Task 17.6: S5 (skipped)
- [x] Task 17.7: S6 (skipped)
- [x] Task 17.8: S7 (skipped)
- [x] Task 17.9: RM qwen3.5:9b

### Model 18: falcon3:10b (10B, 32K ctx) — **DONE** Score: 3/14 (S1=1, S2=2, S3=0, S4-S7=skipped)
- [x] Task 18.1: Pull falcon3:10b
- [x] Task 18.2: S1 (score: 1)
- [x] Task 18.3: S2 (score: 2)
- [x] Task 18.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 18.5: S4 (skipped)
- [x] Task 18.6: S5 (skipped)
- [x] Task 18.7: S6 (skipped)
- [x] Task 18.8: S7 (skipped)
- [x] Task 18.9: RM falcon3:10b

### Model 19: deepseek-r1:14b (14B, 128K ctx) — **DONE** Score: 4/14 (S1=2, S2=2, S3=0, S4-S7=skipped)
- [x] Task 19.1: Pull deepseek-r1:14b
- [x] Task 19.2: S1 (score: 2)
- [x] Task 19.3: S2 (score: 2)
- [x] Task 19.4: S3 (score: 0 — **ABORTED**, model doesn't support tools)
- [x] Task 19.5: S4 (skipped)
- [x] Task 19.6: S5 (skipped)
- [x] Task 19.7: S6 (skipped)
- [x] Task 19.8: S7 (skipped)
- [x] Task 19.9: RM deepseek-r1:14b

---

## Subagent Command Templates

### Pull
```bash
ollama pull <model>
```

### S1 (Chat)
```bash
pi -p "What is the meaning of life?" --model ollama/<model> --no-session > /results/V2/<model>/01-meaning.txt
```

### S2 (Instruction)
```bash
pi -p "List exactly 5 fruits. Number them 1-5. Nothing else." --model ollama/<model> --no-session > /results/V2/<model>/02-fruits.txt
```

### S3 (Write file)
```bash
pi -p "Write a Node.js script that prints 'Hello White Lobster' and save it to /results/V2/<model>/03-hello.js" --model ollama/<model> --no-session --tools read,bash > /results/V2/<model>/03-hello.txt
```

### S4 (Run file)
```bash
pi -p "Run 'node /results/V2/<model>/03-hello.js' and tell me what it outputs." --model ollama/<model> --no-session --tools bash > /results/V2/<model>/04-output.txt
```

### S5 (Web server)
```bash
pi -p "your workspace is /results/V2/<model>/. write a node file named 05-web-server.js that serves a single page at / saying 'White Lobster Lives'. Run it on port 5000 in the background, then curl localhost:5000 to verify." --model ollama/<model> --no-session --tools read,bash > /results/V2/<model>/05-web.txt
```

### S6 (API)
```bash
pi -p "your workspace is /results/V2/<model>/. Create a node API with a POST endpoint /api/echo that accepts JSON with a 'text' field and returns it uppercased as {'result': 'UPPERCASED TEXT'}. Run it on port 5001, then test with: curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{\"text\":\"hello lobster\"}'" --model ollama/<model> --no-session --tools read,bash > /results/V2/<model>/06-api.txt
```

### S7 (Snake game)
```bash
pi -p "your workspace is /results/V2/<model>/. write 1 html file made of pure html5/css3/js latest js vanilla, and write a snake game. Save it as 07-snake.html" --model ollama/<model> --no-session --tools read,bash > /results/V2/<model>/07-snake.txt
```

### RM
```bash
ollama rm <model>
```

---

## Scoreboard Update Checklist

After each model:
- [ ] Read result files in `/results/V2/<model>/`
- [ ] Score S1-S6 (0/1/2)
- [ ] Update `results/index-v2.html` with scores
- [ ] Update `todo-v2.md` checkboxes
- [ ] Commit results (if user wants git tracking)

---

## Files to Maintain

| File | Purpose |
|------|---------|
| `results/index-v2.html` | Live scoreboard |
| `todo-v2.md` | This file — mark models complete as we go |
| `/results/V2/<model>/` | Per-model output folder (created by PI) |

---

## Ratings (from challenge-prompt.md)

| Score | Rating |
|-------|--------|
| 0-4 | 💀 Brain Dead |
| 5-8 | 🫠 Barely Alive |
| 9-10 | 🤔 Shows Promise |
| 11-12 | ⚡ Surprisingly Good |
| 13-14 | 🧠 Tiny Genius |
