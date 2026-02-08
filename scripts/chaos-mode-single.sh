#!/bin/bash
# 🦞⚪ White Lobster — Phase 1: Single Model Selector
# One model does everything. Solo challenge.
#
# Usage:
#   ./chaos-mode-single.sh                  # Show all models
#   ./chaos-mode-single.sh <model>          # Set active model
#   ./chaos-mode-single.sh current          # Show current config

set -e

CONFIG_FILE="/root/.localgpt/config.toml"
BACKUP_FILE="/root/.localgpt/config.toml.bak"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

show_banner() {
  echo ""
  echo -e "${RED}  🦞⚪ WHITE LOBSTER${NC}"
  echo -e "${DIM}  Phase 1: Single Model Challenge${NC}"
  echo -e "${DIM}  ─────────────────────────────────${NC}"
}

list_models() {
  echo ""
  echo -e "  ${RED}━━━ 💀 IMPOSSIBLE (< 500M) ━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${RED}smollm2:135m${NC}          ${DIM}135M${NC}    ${DIM}~150MB${NC}   The absolute floor of intelligence"
  echo -e "  ${RED}functiongemma:270m${NC}    ${DIM}270M${NC}    ${DIM}~250MB${NC}   Tool-calling only, can't freestyle"
  echo -e "  ${RED}smollm2:360m${NC}          ${DIM}360M${NC}    ${DIM}~300MB${NC}   Marginally less hopeless"
  echo -e "  ${RED}qwen2.5:0.5b${NC}          ${DIM}500M${NC}    ${DIM}~400MB${NC}   General purpose, barely"
  echo -e "  ${RED}qwen2.5-coder:0.5b${NC}    ${DIM}500M${NC}    ${DIM}~400MB${NC}   Code-focused but stunted"
  echo ""
  echo -e "  ${YELLOW}━━━ 🔥 HARD (500M - 2B) ━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}qwen3:0.6b${NC}            ${DIM}600M${NC}    ${DIM}~500MB${NC}   Best tiny reasoner"
  echo -e "  ${YELLOW}eternis-tc:0.6b${NC}       ${DIM}600M${NC}    ${DIM}~500MB${NC}   HF tool-calling specialist"
  echo -e "  ${YELLOW}llama3.2:1b${NC}           ${DIM}1B${NC}      ${DIM}~800MB${NC}   Meta's tiny entry"
  echo -e "  ${YELLOW}gemma3:1b${NC}             ${DIM}1B${NC}      ${DIM}~800MB${NC}   Google's tiny, good structure"
  echo -e "  ${YELLOW}qwen2.5:1.5b${NC}          ${DIM}1.5B${NC}    ${DIM}~1.2GB${NC}   Decent general purpose"
  echo -e "  ${YELLOW}qwen2.5-coder:1.5b${NC}    ${DIM}1.5B${NC}    ${DIM}~1.2GB${NC}   Sweet spot coder"
  echo -e "  ${YELLOW}deepseek-r1:1.5b${NC}      ${DIM}1.5B${NC}    ${DIM}~1.2GB${NC}   Chain-of-thought reasoner"
  echo -e "  ${YELLOW}smollm2:1.7b${NC}          ${DIM}1.7B${NC}    ${DIM}~1.4GB${NC}   SmolLM's best shot"
  echo -e "  ${YELLOW}qwen3:1.7b${NC}            ${DIM}1.7B${NC}    ${DIM}~1.4GB${NC}   Solid reasoning for size"
  echo -e "  ${YELLOW}codegemma:2b${NC}          ${DIM}2B${NC}      ${DIM}~1.6GB${NC}   Google code model, good infill"
  echo -e "  ${YELLOW}qwen3-vl:2b${NC}           ${DIM}2B${NC}      ${DIM}~1.6GB${NC}   Can see screenshots of its work"
  echo ""
  echo -e "  ${GREEN}━━━ ⚡ MEDIUM (2B - 4B) ━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${GREEN}qwen2.5:3b${NC}            ${DIM}3B${NC}      ${DIM}~2.4GB${NC}   Solid general purpose"
  echo -e "  ${GREEN}qwen2.5-coder:3b${NC}      ${DIM}3B${NC}      ${DIM}~2.4GB${NC}   ${WHITE}★ Best coder in our range${NC}"
  echo -e "  ${GREEN}llama3.2:3b${NC}           ${DIM}3B${NC}      ${DIM}~2.4GB${NC}   Solid Meta baseline"
  echo -e "  ${GREEN}starcoder2:3b${NC}         ${DIM}3B${NC}      ${DIM}~2.4GB${NC}   BigCode, good completions"
  echo -e "  ${GREEN}qwen3:4b${NC}              ${DIM}4B${NC}      ${DIM}~3.2GB${NC}   ${WHITE}★ Best reasoning in range${NC}"
  echo -e "  ${GREEN}qwen3-vl:4b${NC}           ${DIM}4B${NC}      ${DIM}~3.2GB${NC}   Vision + reasoning"
  echo -e "  ${GREEN}qwen3-tc:4b${NC}           ${DIM}4B${NC}      ${DIM}~3.2GB${NC}   HF tool-calling champion"
  echo ""
  echo -e "  ${DIM}─────────────────────────────────${NC}"
  echo -e "  ${DIM}Usage: ./chaos-mode-single.sh <model-name>${NC}"
  echo ""
}

set_model() {
  local model=$1

  cp "$CONFIG_FILE" "$BACKUP_FILE" 2>/dev/null || true

  cat > "$CONFIG_FILE" <<EOF
# White Lobster — Phase 1: Single Model
# Model: $model
# Generated: $(date -Iseconds)

[agent]
default_model = "ollama/$model"

[providers.ollama]
base_url = "http://localhost:11434"

[heartbeat]
enabled = false

[memory]
workspace = "/root/.localgpt/workspace"
EOF

  echo ""
  echo -e "  ${GREEN}✅ Active model: ${WHITE}$model${NC}"
  echo ""

  # Unload all currently loaded models, then preload the new one
  echo -e "  ${DIM}Unloading all models from Ollama...${NC}"
  loaded=$(curl -s http://localhost:11434/api/ps 2>/dev/null | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
  if [ -n "$loaded" ]; then
    for m in $loaded; do
      curl -s http://localhost:11434/api/generate -d "{\"model\":\"$m\",\"keep_alive\":0}" > /dev/null 2>&1
      echo -e "  ${DIM}  Unloaded $m${NC}"
    done
  fi

  echo -e "  ${DIM}Loading $model...${NC}"
  curl -s http://localhost:11434/api/generate -d "{\"model\":\"$model\",\"prompt\":\"\",\"keep_alive\":\"10m\"}" > /dev/null 2>&1 && \
    echo -e "  ${GREEN}✅ Model loaded in Ollama${NC}" || \
    echo -e "  ${YELLOW}⚠️  Ollama not running — model will load on first use${NC}"

  # Restart LocalGPT daemon if running
  if pgrep -f "localgpt daemon" > /dev/null 2>&1; then
    echo -e "  ${DIM}Restarting LocalGPT daemon...${NC}"
    localgpt daemon stop 2>/dev/null || true
    sleep 1
    localgpt daemon start 2>/dev/null && \
      echo -e "  ${GREEN}✅ LocalGPT restarted with new model${NC}" || \
      echo -e "  ${YELLOW}⚠️  LocalGPT restart failed — start manually${NC}"
  fi

  echo ""
}

show_current() {
  if [ -f "$CONFIG_FILE" ]; then
    echo ""
    echo -e "  ${CYAN}Current config:${NC}"
    echo ""
    cat "$CONFIG_FILE" | sed 's/^/  /'
    echo ""
  else
    echo -e "  ${RED}No config found. Pick a model first.${NC}"
  fi
}

# ============================================

show_banner

case "${1:-}" in
  current)
    show_current
    ;;
  "")
    list_models
    read -p "  Pick a model: " choice
    if [ -n "$choice" ]; then
      set_model "$choice"
    fi
    ;;
  *)
    set_model "$1"
    ;;
esac
