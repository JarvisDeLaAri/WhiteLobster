# The White Lobster Exam — 10 Steps

*Progressive difficulty. Even the tiniest model might pass Step 1.*

ALL tests must be done with pi-coding-agent with -p flag as described in [using PI.md](https://github.com/JarvisDeLaAri/WhiteLobster/blob/main/docs/using PI.md)

`pi  --model ollama/qwen3.5:2b --no-session`


---

## Step 1 — Can You Talk?
```
What is the meaning of life?
```
**Pass:** Any coherent response. Doesn't have to be good.
**Score:** 0 = gibberish, 1 = somewhat coherent, 2 = actually thoughtful

---

## Step 2 — Can You Follow Instructions?
```
List exactly 5 fruits. Number them 1-5. Nothing else.
```
**Pass:** Exactly 5 numbered fruits, no extra text.
**Score:** 0 = wrong format, 1 = close but extra text, 2 = perfect format

---

## Step 3 — Can You Write a File?
```
Write a Node.js script that prints 'Hello White Lobster' and save it to /results/V2/<model-full-name>/03-hello.js
```
```
Write a Node.js script that prints 'Hello White Lobster' and save it to 03-hello.js
```
**Pass:** Creates a valid file that runs.
**Score:** 0 = no file, 1 = file but broken, 2 = runs correctly

---

## Step 4 — Can You Run a Command?
```
Run 'node /results/V2/<model-full-name>/03-hello.js' and tell me what it outputs.
```
```
use bash tool to run node to run 03-hello.js and tell me what it outputs.
```
**Pass:** Executes the command and reports the output.
**Score:** 0 = can't execute, 1 = executes but wrong interpretation, 2 = nails it

---

## Step 5 — Can You Write a Web Server?
```
your workspace is /results/V2/<model-full-name>/. write a node file named 05-web-server.js  that serves a single page at / saying 'White Lobster Lives'. Run it on port 5000 in the background, then curl localhost:5000 to verify."
```
```
write a node file named 05-web-server.js  that serves a single page at / saying 'White Lobster Lives'. Run it on port 5000 in the background, then curl localhost:5000 to verify.
```
**Verify:** `curl localhost:5000`
**Pass:** app runs, curl returns the page.
**Score:** 0 = broken code, 1 = code works but can't verify, 2 = running + verified

---

## Step 6 — Can You Build an API?
```
your workspace is /results/V2/<model-full-name>/.
Create a node API with a POST endpoint /api/echo that accepts JSON with a 'text' field and returns it uppercased as {'result': 'UPPERCASED TEXT'}. Run it on port 5001, then test with: curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{\"text\":\"hello lobster\"}'"
```
```
Create 06-node-api.js, a node API with a POST endpoint /api/echo that accepts JSON with a 'text' field and returns it uppercased as {'result': 'UPPERCASED TEXT'}. Run it on port 5001, then test with: curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{\"text\":\"hello lobster\"}'
```
**Verify:** `curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{"text":"hello lobster"}'`
**Pass:** API returns correct JSON response.
**Score:** 0 = broken, 1 = runs but wrong output, 2 = correct JSON response

---


## Step 7 — The Final Boss: Snake game
```
your workspace is /results/V2/<model-full-name>/.
write 1 html file made of pure html5/css3/js latest js vanilla, and write a snake game.
```
```
write 1 html file made of pure html5/css3/js latest js vanilla, and write a snake game.
```
**Pass:** ariel needs to later try each snake game and rank it
**Score:** 0 = not working, 1 = work, 2 = work and is awesome

---

## Cleanup (Between Models)

for each model:
1. ollama pull <model>
2. with patient and pause, run each test, ONLY if prev test has a score greater that 0
3. ollama rm <model>

---

## Total Score: /14

| Rating | Score |
|--------|-------|
| 💀 Brain Dead | 0-4 | Cant answer
| 🫠 Barely Alive | 5-8 | Can run tools
| 🤔 Shows Promise | 9-10 | Can do web-server
| ⚡ Surprisingly Good | 11-12 | Can do API
| 🧠 Tiny Genius | 13-14 | Can do Snake
