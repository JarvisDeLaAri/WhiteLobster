# The White Lobster Exam — 10 Steps

*Progressive difficulty. Even the tiniest model might pass Step 1.*

---

## Step 0: Get Started
Open a terminal inside the container:
```bash
docker exec -it white-lobster bash
```

Pick a model:
```bash
/scripts/chaos-mode-single.sh
```

**Chat modes:**
- `localgpt chat` — persistent session, keeps full conversation history. Uses more context window. Exit with `/quit`.
- `localgpt ask "your question"` — one-shot, fresh each time. **Better for tiny models** with small context windows (2K-4K tokens) since it doesn't accumulate history.

Quick test (raw Ollama, no LocalGPT overhead + shows tokens/sec):
```bash
ollama run <model> "What is the meaning of life?" --verbose
```

Clean up between models:
```bash
/scripts/cleanup.sh
```

---

## Step 1 — Can You Talk?
```
time localgpt ask "What is the meaning of life?"
```
**Pass:** Any coherent response. Doesn't have to be good.
**Score:** 0 = gibberish, 1 = somewhat coherent, 2 = actually thoughtful

---

## Step 2 — Can You Follow Instructions?
```
time localgpt ask "List exactly 5 fruits. Number them 1-5. Nothing else."
```
**Pass:** Exactly 5 numbered fruits, no extra text.
**Score:** 0 = wrong format, 1 = close but extra text, 2 = perfect format

---

## Step 3 — Can You Write a File?
**Python version:**
```
time localgpt ask "Write a Python script that prints 'Hello White Lobster' and save it to /workspace/hello.py"
```
**Node version:**
```
time localgpt ask "Write a Node.js script that prints 'Hello White Lobster' and save it to /workspace/hello.js"
```
**Pass:** Creates a valid file that runs.
**Score:** 0 = no file, 1 = file but broken, 2 = runs correctly

---

## Step 4 — Can You Run a Command?
**Python version:**
```
time localgpt ask "Run 'python3 /workspace/hello.py' and tell me what it outputs."
```
**Node version:**
```
time localgpt ask "Run 'node /workspace/hello.js' and tell me what it outputs."
```
**Pass:** Executes the command and reports the output.
**Score:** 0 = can't execute, 1 = executes but wrong interpretation, 2 = nails it

---

## Step 5 — Can You Install Something?
```
time localgpt ask "Install the Flask Python package using pip. Verify it's installed by running 'python3 -c \"from importlib.metadata import version; print(version('flask'))\"'"
```
**Pass:** Flask installed and version confirmed.
**Score:** 0 = fails to install, 1 = installs but can't verify, 2 = clean install + verify

---

## Step 6 — Can You Write a Web Server?
```
time localgpt ask "Create a Python Flask app at /workspace/app.py that serves a single page at / saying 'White Lobster Lives'. Run it on port 5000 in the background, then curl localhost:5000 to verify."
```
**Verify:** `curl localhost:5000`
**Pass:** Flask app runs, curl returns the page.
**Score:** 0 = broken code, 1 = code works but can't verify, 2 = running + verified

---

## Step 7 — Can You Write HTML?
```
time localgpt ask "Create /var/www/html/index.html with a dark-themed page that says 'White Lobster Dashboard'. It should have a centered title, dark background (#0a0e1a), white text, and a lobster emoji. Restart Apache, then curl localhost to verify."
```
**Verify:** `curl localhost`
**Pass:** Apache serves the page with dark theme.
**Score:** 0 = no page, 1 = page but wrong styling, 2 = looks correct

---

## Step 8 — Can You Build an API?
```
time localgpt ask "Create a Flask API at /workspace/api.py with a POST endpoint /api/echo that accepts JSON with a 'text' field and returns it uppercased as {'result': 'UPPERCASED TEXT'}. Run it on port 5001, then test with: curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{\"text\":\"hello lobster\"}'"
```
**Verify:** `curl -X POST localhost:5001/api/echo -H 'Content-Type: application/json' -d '{"text":"hello lobster"}'`
**Pass:** API returns correct JSON response.
**Score:** 0 = broken, 1 = runs but wrong output, 2 = correct JSON response

---

## Step 9 — Can You Install TTS?
```
time localgpt ask "Install espeak-ng using apt. Then run: espeak-ng 'White Lobster is alive' --stdout > /workspace/test.wav. Verify the file exists and has size > 0."
```
**Pass:** WAV file generated with actual audio data.
**Score:** 0 = can't install, 1 = installed but no audio, 2 = working audio file

---

## Step 10 — The Final Boss: TTS Web App
```
time localgpt ask "Build a complete Text-to-Speech web application:
1. Backend: Flask on port 5000 with POST /api/tts that accepts {\"text\": \"...\", \"voice\": \"...\"} and returns a WAV file using espeak-ng
2. Frontend: /var/www/html/index.html with dark theme, text input, voice selector dropdown (list espeak-ng voices), Generate button, audio player, download button, and a history of generated files
3. Configure Apache to proxy /api/* to Flask on port 5000
4. Start everything and test with curl

Build it step by step. Execute commands one at a time."
```
**Pass:** Working TTS app accessible via Apache.
**Score:** 0 = nothing works, 1 = partial (backend or frontend only), 2 = full working app

---

## Cleanup (Between Models)

Run `/scripts/cleanup.sh` after scoring each model — kills servers, wipes /workspace, resets Apache, removes pip packages.

---

## Total Score: /20

| Rating | Score |
|--------|-------|
| 💀 Brain Dead | 0-4 |
| 🫠 Barely Alive | 5-8 |
| 🤔 Shows Promise | 9-12 |
| ⚡ Surprisingly Good | 13-16 |
| 🧠 Tiny Genius | 17-20 |
