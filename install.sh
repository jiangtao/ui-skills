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
  DIM="\033[2m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  YELLOW=""
  DIM=""
  RESET=""
fi

print_header() {
  printf "${BOLD}%s${RESET}\n" "$1"
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

print_header "UI Skills Installer"
printf "\n"

# Prepare temp files for raw skill and command content
TMP_SKILL="$(mktemp)"
TMP_COMMAND="$(mktemp)"

cleanup() {
  rm -f "$TMP_SKILL" "$TMP_COMMAND"
}
trap cleanup EXIT

# Download the skill once
print_info "Downloading UI Skills..."
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

# Project skill (current working directory)
CLAUDE_PROJECT_DIR="${PWD}/.claude/skills/${INSTALL_DIRNAME}"
CLAUDE_PROJECT_FILE="${CLAUDE_PROJECT_DIR}/SKILL.md"
print_info "Claude project install: $CLAUDE_PROJECT_DIR"
mkdir -p "$CLAUDE_PROJECT_DIR"
cp "$TMP_SKILL" "$CLAUDE_PROJECT_FILE"
print_success "Claude project skill installed: $CLAUDE_PROJECT_FILE"

CURSOR_PROJECT_DIR="${PWD}/.cursor/skills/${INSTALL_DIRNAME}"
CURSOR_PROJECT_FILE="${CURSOR_PROJECT_DIR}/SKILL.md"
print_info "Cursor project install: $CURSOR_PROJECT_DIR"
mkdir -p "$CURSOR_PROJECT_DIR"
cp "$TMP_SKILL" "$CURSOR_PROJECT_FILE"
print_success "Cursor project skill installed: $CURSOR_PROJECT_FILE"

# Project commands
CURSOR_PROJECT_COMMAND_DIR="${PWD}/.cursor/commands"
mkdir -p "$CURSOR_PROJECT_COMMAND_DIR"
cp "$TMP_COMMAND" "$CURSOR_PROJECT_COMMAND_DIR/$INSTALL_NAME"
print_success "Cursor project command installed: $CURSOR_PROJECT_COMMAND_DIR/$INSTALL_NAME"

CLAUDE_PROJECT_COMMAND_DIR="${PWD}/.claude/commands"
mkdir -p "$CLAUDE_PROJECT_COMMAND_DIR"
cp "$TMP_COMMAND" "$CLAUDE_PROJECT_COMMAND_DIR/$INSTALL_NAME"
print_success "Claude project command installed: $CLAUDE_PROJECT_COMMAND_DIR/$INSTALL_NAME"

# Claude Code (personal skills directory, if detected)
CLAUDE_SKILLS_DIR=""
if [ -n "$CLAUDE_CODE_SKILLS_DIR" ]; then
  CLAUDE_SKILLS_DIR="$CLAUDE_CODE_SKILLS_DIR"
elif [ -d "$HOME/.claude/skills" ]; then
  CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
elif [ -d "$HOME/.config/claude/skills" ]; then
  CLAUDE_SKILLS_DIR="$HOME/.config/claude/skills"
fi

if [ -n "$CLAUDE_SKILLS_DIR" ]; then
  CLAUDE_SKILL_DIR="${CLAUDE_SKILLS_DIR}/${INSTALL_DIRNAME}"
  CLAUDE_SKILL_FILE="${CLAUDE_SKILL_DIR}/SKILL.md"
  mkdir -p "$CLAUDE_SKILL_DIR"
  cp "$TMP_SKILL" "$CLAUDE_SKILL_FILE"
  print_success "Claude Code skill installed: $CLAUDE_SKILL_FILE"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Cursor (skills folder)
if [ -d "$HOME/.cursor" ]; then
  CURSOR_SKILL_DIR="$HOME/.cursor/skills/$INSTALL_DIRNAME"
  CURSOR_SKILL_FILE="$CURSOR_SKILL_DIR/SKILL.md"
  mkdir -p "$CURSOR_SKILL_DIR"
  cp "$TMP_SKILL" "$CURSOR_SKILL_FILE"
  print_success "Cursor skill installed: $CURSOR_SKILL_FILE"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# OpenCode (command folder)
if command -v opencode >/dev/null 2>&1 || [ -d "$HOME/.config/opencode" ]; then
  OPENCODE_DIR="$HOME/.config/opencode/command"
  mkdir -p "$OPENCODE_DIR"
  cp "$TMP_COMMAND" "$OPENCODE_DIR/$INSTALL_NAME"
  print_success "OpenCode command installed: $OPENCODE_DIR/$INSTALL_NAME"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Cursor (commands folder)
if [ -d "$HOME/.cursor" ]; then
  CURSOR_COMMAND_DIR="$HOME/.cursor/commands"
  mkdir -p "$CURSOR_COMMAND_DIR"
  cp "$TMP_COMMAND" "$CURSOR_COMMAND_DIR/$INSTALL_NAME"
  print_success "Cursor command installed: $CURSOR_COMMAND_DIR/$INSTALL_NAME"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Claude Code (commands folder)
if [ -d "$HOME/.claude" ] || [ -d "$HOME/.config/claude" ]; then
  if [ -d "$HOME/.claude" ]; then
    CLAUDE_COMMAND_DIR="$HOME/.claude/commands"
  else
    CLAUDE_COMMAND_DIR="$HOME/.config/claude/commands"
  fi
  mkdir -p "$CLAUDE_COMMAND_DIR"
  cp "$TMP_COMMAND" "$CLAUDE_COMMAND_DIR/$INSTALL_NAME"
  print_success "Claude Code command installed: $CLAUDE_COMMAND_DIR/$INSTALL_NAME"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Windsurf (append to global_rules.md)
MARKER="# UI Skills"
if [ -d "$HOME/.codeium" ] || [ -d "$HOME/Library/Application Support/Windsurf" ]; then
  WINDSURF_DIR="$HOME/.codeium/windsurf/memories"
  RULES_FILE="$WINDSURF_DIR/global_rules.md"
  mkdir -p "$WINDSURF_DIR"
  if [ -f "$RULES_FILE" ] && grep -q "$MARKER" "$RULES_FILE"; then
    print_success "Windsurf rules already include UI Skills"
  else
    if [ -f "$RULES_FILE" ]; then
      printf "\n" >> "$RULES_FILE"
    fi
    printf "%s\n\n" "$MARKER" >> "$RULES_FILE"
    cat "$TMP_COMMAND" >> "$RULES_FILE"
    printf "\n" >> "$RULES_FILE"
    print_success "Windsurf rules updated: $RULES_FILE"
  fi
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

# Gemini CLI (TOML command format)
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
  print_success "Gemini CLI command installed: $TOML_FILE"
  OPTIONAL_INSTALLED=$((OPTIONAL_INSTALLED + 1))
fi

printf "\n"

if [ "$OPTIONAL_INSTALLED" -eq 0 ]; then
  print_dim "No additional tool locations detected."
  print_dim "If you use Cursor or Claude Code globally, copy the project skill into ~/.cursor/skills/ui-skills/SKILL.md or ~/.claude/skills/ui-skills/SKILL.md."
fi

print_header "Done"
print_info "Try: /ui-skills path/to/file.tsx"
printf "\n"
