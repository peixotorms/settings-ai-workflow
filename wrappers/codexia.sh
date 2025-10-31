#!/bin/bash
set -e

# --- Environment setup ---
export OPENAI_API_BASE="https://api.openai.com/v1"
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"
export ZAI_AUTH_TOKEN="{{ZAI_AUTH_TOKEN}}"
export KIMI_AUTH_TOKEN="{{KIMI_AUTH_TOKEN}}"
export DEEPSEEK_AUTH_TOKEN="{{DEEPSEEK_AUTH_TOKEN}}"
export QWEN_AUTH_TOKEN="{{QWEN_AUTH_TOKEN}}"
export OPENROUTER_API_KEY="{{OPENROUTER_API_KEY}}"

# --- Use per-user config directory ---
CONFIG_DIR="${HOME}/.codex"
mkdir -p "$CONFIG_DIR"

# --- Download TOML fresh each run ---
curl -fsSL "https://raw.githubusercontent.com/peixotorms/settings-ai-workflow/main/settings/codex/config.toml" -o "$CONFIG_DIR/config.toml"
chmod 600 "$CONFIG_DIR/config.toml"

# --- Replace placeholders dynamically using the embedded keys ---
# These are already hardcoded after your installer runs as root
sed -i \
  -e "s|{{ZAI_AUTH_TOKEN}}|${ZAI_AUTH_TOKEN}|g" \
  -e "s|{{KIMI_AUTH_TOKEN}}|${KIMI_AUTH_TOKEN}|g" \
  -e "s|{{DEEPSEEK_AUTH_TOKEN}}|${DEEPSEEK_AUTH_TOKEN}|g" \
  -e "s|{{QWEN_AUTH_TOKEN}}|${QWEN_AUTH_TOKEN}|g" \
  -e "s|{{OPENROUTER_API_KEY}}|${OPENROUTER_API_KEY}|g" \
  "$CONFIG_DIR/config.toml"

# --- Run codex ---
exec codex "$@"
