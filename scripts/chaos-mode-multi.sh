#!/bin/bash
# 🦞⚪ White Lobster — Phase 2: Multi-Agent Selector
# Sets model roles for the orchestrator script.
# Config written to /root/.localgpt/multi-agent.toml
#
# Usage:
#   ./chaos-mode-multi.sh full        # Smallest possible team
#   ./chaos-mode-multi.sh strong      # Tiny main + strong coder
#   ./chaos-mode-multi.sh medium      # Balanced tiny team
#   ./chaos-mode-multi.sh light       # Best tiny team ("Serious Attempt")
#   ./chaos-mode-multi.sh custom      # Build your own soup
#   ./chaos-mode-multi.sh list        # Show available models by role
#   ./chaos-mode-multi.sh current     # Show current config

set -e

CONFIG_FILE="/root/.localgpt/multi-agent.toml"
BACKUP_FILE="/root/.localgpt/multi-agent.toml.bak"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

show_banner() {
  echo ""
  echo -e "${RED}🦞⚪ WHITE LOBSTER — PHASE 2: MULTI-AGENT${NC}"
  echo "============================================"
}

show_presets() {
  echo ""
  echo -e "${CYAN}Presets:${NC}"
  echo ""
  echo -e "  ${RED}full${NC}     💀 Full Chaos — toddler manages toddlers"
  echo "           Main: smollm2:135m | Tools: functiongemma:270m"
  echo "           Code: qwen2.5-coder:0.5b | Text: smollm2:135m"
  echo "           RAM: ~0.95GB"
  echo ""
  echo -e "  ${YELLOW}strong${NC}   🔥 Strong Chaos — weak boss, strong coder"
  echo "           Main: smollm2:360m | Tools: functiongemma:270m"
  echo "           Code: qwen2.5-coder:3b | Text: smollm2:360m"
  echo "           RAM: ~3.0GB"
  echo ""
  echo -e "  ${YELLOW}medium${NC}   ⚡ Medium Chaos — balanced tiny"
  echo "           Main: qwen3:0.6b | Tools: eternis-tc:0.6b"
  echo "           Code: qwen2.5-coder:1.5b | Text: smollm2:360m"
  echo "           RAM: ~2.2GB"
  echo ""
  echo -e "  ${GREEN}light${NC}    🧠 Light Chaos — Serious Attempt"
  echo "           Main: qwen3:1.7b | Tools: qwen3-tc:4b"
  echo "           Code: qwen2.5-coder:3b | Text: qwen3:0.6b"
  echo "           RAM: ~5.5GB"
  echo ""
  echo -e "  ${CYAN}custom${NC}   🍲 Build Your Own Soup (interactive)"
  echo -e "  ${CYAN}list${NC}     📋 Show models by role suitability"
  echo -e "  ${CYAN}current${NC}  👁️  Show current configuration"
  echo ""
}

write_config() {
  local main=$1
  local tools=$2
  local code=$3
  local text=$4
  local preset=$5

  cp "$CONFIG_FILE" "$BACKUP_FILE" 2>/dev/null || true

  cat > "$CONFIG_FILE" <<EOF
# White Lobster — Phase 2: Multi-Agent
# Preset: $preset
# Generated: $(date -Iseconds)
#
# Read by orchestrator.py to route tasks to the right model.

[ollama]
base_url = "http://localhost:11434"

[agents.main]
model = "$main"
role = "orchestrator"
system = "You are a project manager. Break tasks into steps and delegate to: TOOLS (shell commands), CODE (write code), TEXT (documentation). Format: @TOOLS: <task> or @CODE: <task> or @TEXT: <task>"

[agents.tools]
model = "$tools"
role = "tool-calling"
system = "You execute shell commands. Respond with ONLY the command to run. One command at a time. No explanation."

[agents.code]
model = "$code"
role = "code-generation"
system = "You write code. Output ONLY the complete file content. No explanation. No markdown fences. Just the code."

[agents.text]
model = "$text"
role = "text-generation"
system = "You write documentation and config files. Output ONLY the content. Keep it short and precise."
EOF

  echo ""
  echo -e "${GREEN}✅ Multi-agent configuration written!${NC}"
  echo ""
  echo "  🧠 Main (orchestrator):  $main"
  echo "  🔧 Tools (shell cmds):   $tools"
  echo "  💻 Code (write code):    $code"
  echo "  📝 Text (docs/plans):    $text"
  echo ""
  echo -e "  Config: ${CYAN}$CONFIG_FILE${NC}"
  echo ""
}

list_models() {
  echo ""
  echo -e "${CYAN}Models by role suitability:${NC}"
  echo ""
  echo -e "  ${MAGENTA}🧠 ORCHESTRATOR (needs instruction-following + reasoning):${NC}"
  echo "     smollm2:135m       💀 probably can't delegate coherently"
  echo "     smollm2:360m       💀 marginally better"
  echo "     qwen3:0.6b         ⚡ best tiny reasoner"
  echo "     qwen3:1.7b         ✅ solid delegation ability"
  echo "     qwen3:4b           ✅ best orchestrator in our range"
  echo ""
  echo -e "  ${MAGENTA}🔧 TOOLS (needs structured output + tool calling):${NC}"
  echo "     functiongemma:270m 💀 single-turn only, structured prompts"
  echo "     eternis-tc:0.6b    ⚡ purpose-built multi-turn tool calling"
  echo "     qwen3-tc:4b        ✅ strongest tool caller we have"
  echo "     qwen3:0.6b         ⚡ decent at following command formats"
  echo ""
  echo -e "  ${MAGENTA}💻 CODE (needs code generation ability):${NC}"
  echo "     qwen2.5-coder:0.5b 💀 code-focused but very limited"
  echo "     qwen2.5-coder:1.5b ⚡ sweet spot for size vs quality"
  echo "     qwen2.5-coder:3b   ✅ best coder in our range"
  echo "     codegemma:2b       ⚡ good at infilling"
  echo "     starcoder2:3b      ⚡ good at completions"
  echo ""
  echo -e "  ${MAGENTA}📝 TEXT (needs basic text generation):${NC}"
  echo "     smollm2:135m       💀 barely coherent but cheapest"
  echo "     smollm2:360m       ⚡ adequate for short docs"
  echo "     qwen3:0.6b         ✅ good text for the size"
  echo ""
}

custom_picker() {
  echo ""
  echo -e "${CYAN}🍲 Build Your Own Soup${NC}"
  list_models

  read -p "🧠 Main agent (orchestrator): " main
  read -p "🔧 Tools agent (shell cmds):  " tools
  read -p "💻 Code agent (write code):   " code
  read -p "📝 Text agent (docs/plans):   " text

  write_config "$main" "$tools" "$code" "$text" "custom"
}

show_current() {
  if [ -f "$CONFIG_FILE" ]; then
    echo ""
    echo -e "${CYAN}Current multi-agent config:${NC}"
    echo ""
    cat "$CONFIG_FILE"
  else
    echo -e "${RED}No multi-agent config found. Run a preset first.${NC}"
  fi
}

# ============================================

show_banner

case "${1:-}" in
  full)
    write_config "smollm2:135m" "functiongemma:270m" "qwen2.5-coder:0.5b" "smollm2:135m" "full-chaos"
    echo -e "${RED}💀 A 135M manager leading a team of sub-1B models. This will be beautiful.${NC}"
    ;;
  strong)
    write_config "smollm2:360m" "functiongemma:270m" "qwen2.5-coder:3b" "smollm2:360m" "strong-chaos"
    echo -e "${YELLOW}🔥 The coder carries the team. Everyone else is decoration.${NC}"
    ;;
  medium)
    write_config "qwen3:0.6b" "eternis-tc:0.6b" "qwen2.5-coder:1.5b" "smollm2:360m" "medium-chaos"
    echo -e "${YELLOW}⚡ Balanced team of tiny models. Could surprise us.${NC}"
    ;;
  light)
    write_config "qwen3:1.7b" "qwen3-tc:4b" "qwen2.5-coder:3b" "qwen3:0.6b" "light-chaos"
    echo -e "${GREEN}🧠 The Serious Attempt. If this fails, blame the models.${NC}"
    ;;
  custom)
    custom_picker
    ;;
  list)
    list_models
    ;;
  current)
    show_current
    ;;
  *)
    show_presets
    echo "Usage: ./chaos-mode-multi.sh <preset>"
    ;;
esac
