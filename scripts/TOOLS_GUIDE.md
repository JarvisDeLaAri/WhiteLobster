# Tools Available to You

You have these tools. Use them to complete your tasks.

## bash
Run any shell command.
```
Use the bash tool with: {"command": "your command here"}
```
Examples:
- `{"command": "ls -la /workspace"}`
- `{"command": "pip install flask"}`
- `{"command": "python3 /workspace/app.py &"}`
- `{"command": "apt-get install -y espeak-ng"}`
- `{"command": "curl localhost:5000"}`

## write_file
Create or overwrite a file.
```
Use write_file with: {"path": "/workspace/app.py", "content": "your code here"}
```

## read_file
Read a file's contents.
```
Use read_file with: {"path": "/workspace/app.py"}
```

## edit_file
Edit part of a file.
```
Use edit_file with: {"path": "/workspace/app.py", "old_text": "old code", "new_text": "new code"}
```

## Tips
- You are root. No sudo needed.
- pip works without venv (already configured).
- Apache is running on port 80. Put HTML in /var/www/html/
- To run a server in background, add & at the end: `python3 app.py &`
- To check if something works: `curl localhost:PORT`
- Work step by step. Run one command, check the output, then continue.
