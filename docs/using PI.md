Use `-p` (print mode) for non-interactive:

```bash
pi -p "your task here" --provider ollama --model llama3.1
```

Or shorter with provider prefix:
```bash
pi -p "your task here" --model ollama/llama3.1
```

Key flags for your use case:
| Flag | What it does |
|------|-------------|
| `-p` | Non-interactive, process and exit |
| `--model ollama/llama3.1` | Use specific Ollama model |
| `--no-session` | Don't save to session file |
| `--tools read,bash` | Limit which tools it can use |
| `--mode json` | Output as JSON events instead of text |

Example:
```bash
pi -p "List all .py files and count lines" --model ollama/kimi-k2.6:cloud --no-session
```