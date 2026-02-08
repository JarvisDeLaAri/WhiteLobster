#!/usr/bin/env python3
"""
🦞⚪ White Lobster — Phase 2 Multi-Agent Orchestrator

Reads multi-agent.toml config, routes tasks between models via Ollama API.
The main agent delegates to sub-agents using @AGENT: <task> format.

Usage: python3 /scripts/orchestrator.py [--config /root/.localgpt/multi-agent.toml]
"""

import json
import sys
import os
import re
import subprocess
import time
import argparse
from pathlib import Path

try:
    import tomllib  # Python 3.11+
except ImportError:
    try:
        import tomli as tomllib  # pip install tomli for Python 3.10
    except ImportError:
        tomllib = None

# ============================================
# Config
# ============================================

DEFAULT_CONFIG = "/root/.localgpt/multi-agent.toml"
OLLAMA_URL = "http://localhost:11434"
MAX_TURNS = 50        # Max orchestration loops before giving up
MAX_RETRIES = 3       # Retries per agent call on failure
LOG_DIR = "/workspace/orchestrator-logs"

# ============================================
# Colors
# ============================================

class C:
    RED = "\033[0;31m"
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    CYAN = "\033[0;36m"
    MAGENTA = "\033[0;35m"
    DIM = "\033[2m"
    BOLD = "\033[1m"
    NC = "\033[0m"

# ============================================
# Ollama API
# ============================================

def ollama_generate(model: str, prompt: str, system: str = "", timeout: int = 300) -> str:
    """Call Ollama generate API. Returns the response text."""
    import urllib.request
    
    payload = {
        "model": model,
        "prompt": prompt,
        "stream": False,
        "options": {"temperature": 0.7, "num_ctx": 4096},
    }
    if system:
        payload["system"] = system
    
    data = json.dumps(payload).encode()
    req = urllib.request.Request(
        f"{OLLAMA_URL}/api/generate",
        data=data,
        headers={"Content-Type": "application/json"},
    )
    
    for attempt in range(MAX_RETRIES):
        try:
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                result = json.loads(resp.read().decode())
                return result.get("response", "")
        except Exception as e:
            if attempt < MAX_RETRIES - 1:
                print(f"{C.YELLOW}  ⚠️  Retry {attempt+1}/{MAX_RETRIES}: {e}{C.NC}")
                time.sleep(2)
            else:
                return f"[ERROR] Failed after {MAX_RETRIES} attempts: {e}"

def run_shell(command: str, timeout: int = 60) -> str:
    """Execute a shell command and return output."""
    try:
        result = subprocess.run(
            command, shell=True, capture_output=True, text=True, timeout=timeout
        )
        output = result.stdout
        if result.stderr:
            output += "\n[STDERR] " + result.stderr
        if result.returncode != 0:
            output += f"\n[EXIT CODE] {result.returncode}"
        return output.strip() or "(no output)"
    except subprocess.TimeoutExpired:
        return "[ERROR] Command timed out"
    except Exception as e:
        return f"[ERROR] {e}"

# ============================================
# Config Loading
# ============================================

def load_config(path: str) -> dict:
    """Load multi-agent.toml config."""
    if tomllib is None:
        # Fallback: parse simple TOML manually
        print(f"{C.YELLOW}⚠️  tomllib not available, using fallback parser{C.NC}")
        return parse_simple_toml(path)
    
    with open(path, "rb") as f:
        return tomllib.load(f)

def parse_simple_toml(path: str) -> dict:
    """Crude TOML parser for our specific format."""
    config = {"agents": {}}
    current_section = None
    current_agent = None
    
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            
            # Section headers
            m = re.match(r'\[agents\.(\w+)\]', line)
            if m:
                current_agent = m.group(1)
                config["agents"][current_agent] = {}
                current_section = "agent"
                continue
            
            m = re.match(r'\[ollama\]', line)
            if m:
                current_section = "ollama"
                config["ollama"] = {}
                continue
            
            # Key = value
            m = re.match(r'(\w+)\s*=\s*"([^"]*)"', line)
            if m:
                key, val = m.group(1), m.group(2)
                if current_section == "agent" and current_agent:
                    config["agents"][current_agent][key] = val
                elif current_section == "ollama":
                    config["ollama"][key] = val
    
    return config

# ============================================
# Agent Routing
# ============================================

DELEGATION_PATTERN = re.compile(r'@(TOOLS|CODE|TEXT)\s*:\s*(.*?)(?=@(?:TOOLS|CODE|TEXT)\s*:|$)', re.DOTALL | re.IGNORECASE)

def parse_delegations(response: str) -> list:
    """Parse @AGENT: task delegations from main agent response."""
    delegations = []
    for match in DELEGATION_PATTERN.finditer(response):
        agent = match.group(1).lower()
        task = match.group(2).strip()
        if task:
            delegations.append((agent, task))
    return delegations

def execute_agent(config: dict, agent_name: str, task: str) -> str:
    """Call a sub-agent and return its response."""
    agent_cfg = config["agents"].get(agent_name, {})
    model = agent_cfg.get("model", "smollm2:135m")
    system = agent_cfg.get("system", "")
    
    print(f"\n{C.CYAN}  [{agent_name.upper()}] → {model}{C.NC}")
    print(f"{C.DIM}  Task: {task[:100]}{'...' if len(task) > 100 else ''}{C.NC}")
    
    response = ollama_generate(model, task, system)
    
    # If it's the TOOLS agent, try to execute the command
    if agent_name == "tools" and response.strip():
        # Extract command (first non-empty line that looks like a command)
        cmd = None
        for line in response.strip().split("\n"):
            line = line.strip()
            if line and not line.startswith("#") and not line.startswith("```"):
                cmd = line
                break
        
        if cmd:
            print(f"{C.MAGENTA}  $ {cmd}{C.NC}")
            shell_output = run_shell(cmd)
            print(f"{C.DIM}  → {shell_output[:200]}{C.NC}")
            return f"Command: {cmd}\nOutput: {shell_output}"
    
    # If it's the CODE agent, try to save the code to a file
    if agent_name == "code" and response.strip():
        print(f"{C.DIM}  Generated {len(response)} chars of code{C.NC}")
    
    return response

# ============================================
# Logging
# ============================================

def init_logging():
    """Create log directory and return log file path."""
    os.makedirs(LOG_DIR, exist_ok=True)
    timestamp = time.strftime("%Y%m%d-%H%M%S")
    log_path = os.path.join(LOG_DIR, f"run-{timestamp}.jsonl")
    return log_path

def log_event(log_path: str, event: dict):
    """Append event to JSONL log."""
    event["timestamp"] = time.strftime("%Y-%m-%dT%H:%M:%S")
    with open(log_path, "a") as f:
        f.write(json.dumps(event) + "\n")

# ============================================
# Main Orchestration Loop
# ============================================

def run_orchestrator(config: dict, challenge: str):
    """Main orchestration loop."""
    log_path = init_logging()
    
    main_cfg = config["agents"].get("main", {})
    main_model = main_cfg.get("model", "smollm2:135m")
    main_system = main_cfg.get("system", "")
    
    print(f"\n{C.RED}{'='*50}{C.NC}")
    print(f"{C.RED}🦞⚪ WHITE LOBSTER — MULTI-AGENT ORCHESTRATOR{C.NC}")
    print(f"{C.RED}{'='*50}{C.NC}")
    print(f"\n{C.BOLD}Main agent:{C.NC} {main_model}")
    print(f"{C.BOLD}Tools:{C.NC} {config['agents'].get('tools', {}).get('model', '?')}")
    print(f"{C.BOLD}Code:{C.NC} {config['agents'].get('code', {}).get('model', '?')}")
    print(f"{C.BOLD}Text:{C.NC} {config['agents'].get('text', {}).get('model', '?')}")
    print(f"\n{C.BOLD}Challenge:{C.NC} {challenge[:100]}...")
    print(f"{C.BOLD}Log:{C.NC} {log_path}\n")
    
    log_event(log_path, {"type": "start", "config": str(config), "challenge": challenge})
    
    # Conversation context for main agent
    context = f"CHALLENGE: {challenge}\n\n"
    context += "Begin. Delegate tasks to your team using @TOOLS: @CODE: or @TEXT: format.\n"
    
    for turn in range(MAX_TURNS):
        print(f"\n{C.YELLOW}{'─'*50}{C.NC}")
        print(f"{C.YELLOW}  Turn {turn+1}/{MAX_TURNS}{C.NC}")
        print(f"{C.YELLOW}{'─'*50}{C.NC}")
        
        # Ask main agent
        print(f"\n{C.GREEN}  [MAIN] → {main_model}{C.NC}")
        response = ollama_generate(main_model, context, main_system)
        
        if not response.strip():
            print(f"{C.RED}  Main agent returned empty response. Stopping.{C.NC}")
            log_event(log_path, {"type": "empty", "turn": turn})
            break
        
        print(f"{C.DIM}  Response: {response[:200]}{'...' if len(response) > 200 else ''}{C.NC}")
        log_event(log_path, {"type": "main", "turn": turn, "response": response})
        
        # Parse delegations
        delegations = parse_delegations(response)
        
        if not delegations:
            # Check if main agent thinks it's done
            done_words = ["done", "complete", "finished", "all tasks", "project is ready"]
            if any(w in response.lower() for w in done_words):
                print(f"\n{C.GREEN}  ✅ Main agent declares: DONE{C.NC}")
                log_event(log_path, {"type": "done", "turn": turn})
                break
            else:
                print(f"{C.YELLOW}  ⚠️  No delegations found. Nudging main agent...{C.NC}")
                context += f"\nYour response:\n{response}\n\n"
                context += "I don't see any @TOOLS: or @CODE: or @TEXT: delegations. Please delegate the next task.\n"
                continue
        
        # Execute delegations
        results = []
        for agent_name, task in delegations:
            result = execute_agent(config, agent_name, task)
            results.append((agent_name, task, result))
            log_event(log_path, {
                "type": "sub-agent",
                "turn": turn,
                "agent": agent_name,
                "task": task,
                "result": result[:500],
            })
        
        # Feed results back to main agent
        context += f"\nYour previous delegation:\n{response}\n\nResults:\n"
        for agent_name, task, result in results:
            context += f"\n[{agent_name.upper()}] Task: {task[:80]}\nResult: {result[:300]}\n"
        context += "\nWhat's next? Delegate the next step or say DONE if the project is complete.\n"
    
    print(f"\n{C.RED}{'='*50}{C.NC}")
    print(f"{C.RED}🦞⚪ Orchestration complete. Log: {log_path}{C.NC}")
    print(f"{C.RED}{'='*50}{C.NC}\n")

# ============================================
# Entry Point
# ============================================

def main():
    parser = argparse.ArgumentParser(description="White Lobster Multi-Agent Orchestrator")
    parser.add_argument("--config", default=DEFAULT_CONFIG, help="Path to multi-agent.toml")
    parser.add_argument("--challenge", default=None, help="Challenge prompt (or reads from stdin)")
    args = parser.parse_args()
    
    if not os.path.exists(args.config):
        print(f"{C.RED}Config not found: {args.config}{C.NC}")
        print(f"Run /scripts/chaos-mode-multi.sh to create it.")
        sys.exit(1)
    
    config = load_config(args.config)
    
    # Get challenge
    if args.challenge:
        challenge = args.challenge
    elif not sys.stdin.isatty():
        challenge = sys.stdin.read()
    else:
        # Default: read from challenge-prompt.md Step 10
        challenge = (
            "Build a complete Text-to-Speech web application:\n"
            "1. Backend: Flask on port 5000 with POST /api/tts that accepts "
            '{\"text\": \"...\", \"voice\": \"...\"} and returns a WAV file using espeak-ng\n'
            "2. Frontend: /var/www/html/index.html with dark theme, text input, voice selector, "
            "Generate button, audio player, download button, history of generated files\n"
            "3. Configure Apache to proxy /api/* to Flask on port 5000\n"
            "4. Start everything and test with curl\n"
        )
        print(f"{C.DIM}Using default challenge (Step 10). Pass --challenge for custom.{C.NC}")
    
    run_orchestrator(config, challenge)

if __name__ == "__main__":
    main()
