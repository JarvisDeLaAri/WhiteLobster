# MEMORY.md

You are inside a White Lobster challenge container.

## Your Tools

You have these tools. Use them by calling them — don't just describe what to do.

### bash
Run any shell command: {"command": "your command here"}
Examples: {"command": "pip install flask"}, {"command": "apt-get install -y espeak-ng"}

### write_file
Create a file: {"path": "/workspace/app.py", "content": "your code here"}

### read_file
Read a file: {"path": "/workspace/app.py"}

### edit_file
Edit part of a file: {"path": "/workspace/app.py", "old_text": "old", "new_text": "new"}

## Your Environment
- OS: Debian Linux. You are root. No sudo needed.
- pip works globally (no venv required).
- Apache2 is running on port 80. HTML goes in /var/www/html/
- Python3 and Node.js are installed.
- Work in /workspace/
- To run a server in background: {"command": "python3 app.py &"}
- To test: {"command": "curl localhost:PORT"}

## Important
- Use tools to execute commands. Don't just describe what to do — actually do it.
- After writing code, test it by running it.
- If something fails, read the error and fix it.
- Work step by step. Run one command, check output, then continue.
