#!/bin/sh
set -e

# UI Skills installer
# Installs the skill into project skill directories for Cursor and Claude,
# plus optional command locations for supported tools.

# Colors (only if stdout is a TTY)
if [ -t 1 ]; then
  BOLD="\033[1m"
  GREEN="\033[32m"
  YELLOW="\033[33m"
  GRAY="\033[37m"
  DARK="\033[90m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  YELLOW=""
  GRAY=""
  DARK=""
  RESET=""
fi

print_header() {
  printf "${BOLD}%s${RESET}\n" "$1"
}

print_ascii() {
  B="${GRAY}"   # Blocks (Light Gray)
  D="${DARK}"   # Connectors (Dark Gray)
  R="${RESET}"

  printf " ${B}██${D}╗   ${B}██${D}╗${B}██${D}╗      ${B}███████${D}╗${B}██${D}╗  ${B}██${D}╗${B}██${D}╗${B}██${D}╗     ${B}██${D}╗     ${B}███████${D}╗\n"
  printf " ${B}██${D}║   ${B}██${D}║${B}██${D}║      ${B}██${D}╔════╝${B}██${D}║ ${B}██${D}╔╝${B}██${D}║${B}██${D}║     ${B}██${D}║     ${B}██${D}╔════╝\n"
  printf " ${B}██${D}║   ${B}██${D}║${B}██${D}║${B}█████${D}╗${B}███████${D}╗${B}█████${D}╔╝ ${B}██${D}║${B}██${D}║     ${B}██${D}║     ${B}███████${D}╗\n"
  printf " ${B}██${D}║   ${B}██${D}║${B}██${D}║${D}╚════╝╚════${B}██${D}║${B}██${D}╔═${B}██${D}╗ ${B}██${D}║${B}██${D}║     ${B}██${D}║     ${D}╚════${B}██${D}║\n"
  printf " ${D}╚${B}██████${D}╔╝${B}██${D}║      ${B}███████${D}║${B}██${D}║  ${B}██${D}╗${B}██${D}║${B}███████${D}╗${B}███████${D}╗${B}███████${D}║\n"
  printf "  ${D}╚═════╝ ╚═╝      ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝${R}\n"
  printf "\n"
  printf "  ${DARK}The open taste layer for agent-generated UI.${R}\n"
}

print_success() {
  printf "${GREEN}✓${RESET} %s\n" "$1"
}

print_info() {
  printf "${YELLOW}→${RESET} %s\n" "$1"
}

print_dim() {
  printf "${DIM}%s${RESET}\n" "$1"
}

print_error() {
  printf "${BOLD}Error:${RESET} %s\n" "$1" >&2
}

# Configuration
SKILL_URL="https://ui-skills.com/llms.txt"
INSTALL_NAME="ui-skills.md"
INSTALL_DIRNAME="ui-skills"

print_ascii
printf "\n"

# Selective installation configuration
SELECTIVE_MODE=false
SELECTED_TOOLS=""

# Parse command-line arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --only)
      if [ -n "$2" ]; then
        SELECTIVE_MODE=true
        SELECTED_TOOLS="$2"
        shift 2
      else
        print_error "--only requires a tool name or comma-separated list"
        echo "Usage: $0 --only claude"
        echo "       $0 --only claude,cursor"
        echo ""
        echo "Supported tools: claude, cursor, opencode, codex, gemini, windsurf,"
        echo "                 amp, kilocode, roo, goose, antigravity, copilot, clawdbot, droid"
        exit 1
      fi
      ;;
    --help|-h)
      echo "UI Skills Installer"
      echo ""
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --only TOOLS    Install only to specified tools (comma-separated)"
      echo "  --help, -h      Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 --only claude           # Install only to Claude Code"
      echo "  $0 --only claude,cursor    # Install to Claude Code and Cursor"
      echo ""
      echo "Supported tools: claude, cursor, opencode, codex, gemini, windsurf,"
      echo "                 amp, kilocode, roo, goose, antigravity, copilot, clawdbot, droid"
      echo ""
      echo "Without --only, the script auto-detects and installs to all available tools."
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# should_install_tool: Check if a tool should be installed based on selective mode
# Args:
#   $1 = tool_identifier (e.g., "claude", "cursor", "opencode")
# Returns: 0 (true) if should install, 1 (false) if should skip
should_install_tool() {
  tool_id="$1"

  # If not in selective mode, install to all detected tools (backward compatible)
  if [ "$SELECTIVE_MODE" = false ]; then
    return 0
  fi

  # In selective mode, check if tool is in the selected list
  for selected_tool in $(echo "$SELECTED_TOOLS" | tr ',' ' '); do
    # Normalize to lowercase for comparison
    normalized_selected=$(echo "$selected_tool" | tr '[:upper:]' '[:lower:]')
    if [ "$tool_id" = "$normalized_selected" ]; then
      return 0
    fi
  done

  return 1
}

# Prepare temp files for raw skill and command content
TMP_SKILL="$(mktemp)"
TMP_COMMAND="$(mktemp)"

cleanup() {
  rm -f "$TMP_SKILL" "$TMP_COMMAND"
}
trap cleanup EXIT

# Download the skill once
print_info "Downloading..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SKILL_URL" -o "$TMP_SKILL"
elif command -v wget >/dev/null 2>&1; then
  wget -q "$SKILL_URL" -O "$TMP_SKILL"
else
  print_error "Neither curl nor wget found. Please install one of them."
  exit 1
fi

if [ ! -s "$TMP_SKILL" ]; then
  print_error "Download failed or returned empty content."
  exit 1
fi

# Use full skill content for command installs
cp "$TMP_SKILL" "$TMP_COMMAND"

printf "\n"

OPTIONAL_INSTALLED=0

install_skill() {
  base_dir="$1"
  label="$2"
  skill_dir="$base_dir/$INSTALL_DIRNAME"
  skill_file="$skill_dir/SKILL.md"
  mkdir -p "$skill_dir"
  cp "$TMP_SKILL" "$skill_file"
  print_success "$label skill installed"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
}

maybe_install_project_skill() {
  base_dir="$1"
  label="$2"
  skill_dir="$base_dir/$INSTALL_DIRNAME"
  skill_file="$skill_dir/SKILL.md"
  if [ -d "$base_dir" ]; then
    mkdir -p "$skill_dir"
    cp "$TMP_SKILL" "$skill_file"
    print_success "$label project skill installed"
    OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
  fi
}

# Project skills (auto-detect)
if should_install_tool "opencode"; then
  maybe_install_project_skill "${PWD}/.opencode/skill" "OpenCode"
fi
if should_install_tool "claude"; then
  maybe_install_project_skill "${PWD}/.claude/skills" "Claude Code"
fi
if should_install_tool "codex"; then
  maybe_install_project_skill "${PWD}/.codex/skills" "Codex"
fi
if should_install_tool "cursor"; then
  maybe_install_project_skill "${PWD}/.cursor/skills" "Cursor"
fi
if should_install_tool "amp"; then
  maybe_install_project_skill "${PWD}/.agents/skills" "Amp"
fi
if should_install_tool "kilocode"; then
  maybe_install_project_skill "${PWD}/.kilocode/skills" "Kilo Code"
fi
if should_install_tool "roo"; then
  maybe_install_project_skill "${PWD}/.roo/skills" "Roo Code"
fi
if should_install_tool "goose"; then
  maybe_install_project_skill "${PWD}/.goose/skills" "Goose"
fi
if should_install_tool "gemini"; then
  maybe_install_project_skill "${PWD}/.gemini/skills" "Gemini CLI"
fi
if should_install_tool "antigravity"; then
  maybe_install_project_skill "${PWD}/.agent/skills" "Antigravity"
fi
if should_install_tool "copilot"; then
  maybe_install_project_skill "${PWD}/.github/skills" "GitHub Copilot"
fi
if should_install_tool "clawdbot"; then
  maybe_install_project_skill "${PWD}/skills" "Clawdbot"
fi
if should_install_tool "droid"; then
  maybe_install_project_skill "${PWD}/.factory/skills" "Droid"
fi
if should_install_tool "windsurf"; then
  maybe_install_project_skill "${PWD}/.windsurf/skills" "Windsurf"
fi

# Claude Code (project commands)
if should_install_tool "claude" && [ -d "${PWD}/.claude" ]; then
  CLAUDE_PROJECT_COMMAND_DIR="${PWD}/.claude/commands"
  mkdir -p "$CLAUDE_PROJECT_COMMAND_DIR"
  cp "$TMP_COMMAND" "$CLAUDE_PROJECT_COMMAND_DIR/$INSTALL_NAME"
  print_success "Claude project command installed"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Cursor (project commands)
if should_install_tool "cursor" && [ -d "${PWD}/.cursor" ]; then
  CURSOR_PROJECT_COMMAND_DIR="${PWD}/.cursor/commands"
  mkdir -p "$CURSOR_PROJECT_COMMAND_DIR"
  cp "$TMP_COMMAND" "$CURSOR_PROJECT_COMMAND_DIR/$INSTALL_NAME"
  print_success "Cursor project command installed"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Claude Code (personal skills directory, if detected)
if should_install_tool "claude"; then
  CLAUDE_SKILLS_DIR=""
  if [ -n "$CLAUDE_CODE_SKILLS_DIR" ]; then
    CLAUDE_SKILLS_DIR="$CLAUDE_CODE_SKILLS_DIR"
  elif [ -d "$HOME/.claude/skills" ]; then
    CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
  elif [ -d "$HOME/.config/claude/skills" ]; then
    CLAUDE_SKILLS_DIR="$HOME/.config/claude/skills"
  fi

  if [ -n "$CLAUDE_SKILLS_DIR" ]; then
    install_skill "$CLAUDE_SKILLS_DIR" "Claude Code"
  fi
fi

# OpenCode (skills folder)
if should_install_tool "opencode" && [ -d "$HOME/.config/opencode/skill" ]; then
  install_skill "$HOME/.config/opencode/skill" "OpenCode"
fi

# Codex (skills folder)
if should_install_tool "codex" && [ -d "$HOME/.codex/skills" ]; then
  install_skill "$HOME/.codex/skills" "Codex"
fi

# Cursor (skills folder)
if should_install_tool "cursor" && [ -d "$HOME/.cursor/skills" ]; then
  install_skill "$HOME/.cursor/skills" "Cursor"
fi

# Amp (skills folder)
if should_install_tool "amp" && [ -d "$HOME/.config/agents/skills" ]; then
  install_skill "$HOME/.config/agents/skills" "Amp"
fi

# Kilo Code (skills folder)
if should_install_tool "kilocode" && [ -d "$HOME/.kilocode/skills" ]; then
  install_skill "$HOME/.kilocode/skills" "Kilo Code"
fi

# Roo Code (skills folder)
if should_install_tool "roo" && [ -d "$HOME/.roo/skills" ]; then
  install_skill "$HOME/.roo/skills" "Roo Code"
fi

# Goose (skills folder)
if should_install_tool "goose" && [ -d "$HOME/.config/goose/skills" ]; then
  install_skill "$HOME/.config/goose/skills" "Goose"
fi

# Gemini CLI (skills folder)
if should_install_tool "gemini" && [ -d "$HOME/.gemini/skills" ]; then
  install_skill "$HOME/.gemini/skills" "Gemini CLI"
fi

# Antigravity (skills folder)
if should_install_tool "antigravity" && [ -d "$HOME/.gemini/antigravity/skills" ]; then
  install_skill "$HOME/.gemini/antigravity/skills" "Antigravity"
fi

# GitHub Copilot (skills folder)
if should_install_tool "copilot" && [ -d "$HOME/.copilot/skills" ]; then
  install_skill "$HOME/.copilot/skills" "GitHub Copilot"
fi

# Clawdbot (skills folder)
if should_install_tool "clawdbot" && [ -d "$HOME/.clawdbot/skills" ]; then
  install_skill "$HOME/.clawdbot/skills" "Clawdbot"
fi

# Droid (skills folder)
if should_install_tool "droid" && [ -d "$HOME/.factory/skills" ]; then
  install_skill "$HOME/.factory/skills" "Droid"
fi

# Windsurf (skills folder)
if should_install_tool "windsurf" && [ -d "$HOME/.codeium/windsurf/skills" ]; then
  install_skill "$HOME/.codeium/windsurf/skills" "Windsurf"
fi

# OpenCode (command folder)
if should_install_tool "opencode"; then
  if command -v opencode >/dev/null 2>&1 || [ -d "$HOME/.config/opencode" ]; then
    OPENCODE_COMMAND_DIR="$HOME/.config/opencode/command"
    mkdir -p "$OPENCODE_COMMAND_DIR"
    cp "$TMP_COMMAND" "$OPENCODE_COMMAND_DIR/$INSTALL_NAME"
    print_success "OpenCode command installed"
    OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
  fi
fi

# Cursor (commands folder)
if should_install_tool "cursor" && [ -d "$HOME/.cursor" ]; then
  CURSOR_COMMAND_DIR="$HOME/.cursor/commands"
  mkdir -p "$CURSOR_COMMAND_DIR"
  cp "$TMP_COMMAND" "$CURSOR_COMMAND_DIR/$INSTALL_NAME"
  print_success "Cursor command installed"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Claude Code (commands folder)
if should_install_tool "claude"; then
  if [ -d "$HOME/.claude" ] || [ -d "$HOME/.config/claude" ]; then
    if [ -d "$HOME/.claude" ]; then
      CLAUDE_COMMAND_DIR="$HOME/.claude/commands"
    else
      CLAUDE_COMMAND_DIR="$HOME/.config/claude/commands"
    fi
    mkdir -p "$CLAUDE_COMMAND_DIR"
    cp "$TMP_COMMAND" "$CLAUDE_COMMAND_DIR/$INSTALL_NAME"
    print_success "Claude Code command installed"
    OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
  fi
fi

# Windsurf (append to global_rules.md)
if should_install_tool "windsurf"; then
  MARKER="# UI Skills"
  if [ -d "$HOME/.codeium" ] || [ -d "$HOME/Library/Application Support/Windsurf" ]; then
    WINDSURF_DIR="$HOME/.codeium/windsurf/memories"
    RULES_FILE="$WINDSURF_DIR/global_rules.md"
    mkdir -p "$WINDSURF_DIR"
    if [ -f "$RULES_FILE" ] && grep -q "$MARKER" "$RULES_FILE"; then
      print_success "Windsurf already updated"
    else
      if [ -f "$RULES_FILE" ]; then
        printf "\n" >> "$RULES_FILE"
      fi
      printf "%s\n\n" "$MARKER" >> "$RULES_FILE"
      cat "$TMP_COMMAND" >> "$RULES_FILE"
      printf "\n" >> "$RULES_FILE"
      print_success "Windsurf updated"
    fi
    OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
  fi
fi

# Gemini CLI (TOML command format)
if should_install_tool "gemini"; then
  if command -v gemini >/dev/null 2>&1 || [ -d "$HOME/.gemini" ]; then
    GEMINI_DIR="$HOME/.gemini/commands"
    TOML_FILE="$GEMINI_DIR/ui-skills.toml"
    mkdir -p "$GEMINI_DIR"
    cat > "$TOML_FILE" << 'TOMLEOF'
description = "Review UI code with UI Skills constraints"
prompt = """
TOMLEOF
    cat "$TMP_COMMAND" >> "$TOML_FILE"
    printf "\n\"\"\"\n" >> "$TOML_FILE"
    print_success "Gemini CLI command installed"
    OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
  fi
fi

printf "\n"

if [ "$OPTIONAL_INSTALLED" -eq 0 ]; then
  print_dim "No additional tool locations detected."
  print_dim "Create a tool's skills directory and rerun to install automatically."
fi

print_header "Done"
print_info "Usage: /ui-skills path/to/file.tsx"
printf "\n"
