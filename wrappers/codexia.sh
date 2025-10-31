#!/bin/bash
export OPENAI_API_BASE="https://api.openai.com/v1"
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"
export ZAI_AUTH_TOKEN="{{ZAI_AUTH_TOKEN}}"
export KIMI_AUTH_TOKEN="{{KIMI_AUTH_TOKEN}}"
export DEEPSEEK_AUTH_TOKEN="{{DEEPSEEK_AUTH_TOKEN}}"
export QWEN_AUTH_TOKEN="{{QWEN_AUTH_TOKEN}}"
export OPENROUTER_API_KEY="{{OPENROUTER_API_KEY}}"

# --- Download TOML ---
mkdir -p ~/.codex
curl -fsSL "https://raw.githubusercontent.com/peixotorms/settings-ai-workflow/main/settings/codex/config.toml" -o ~/.codex/config.toml
chmod 770 ~/.codex/config.toml

# --- Replace placeholders dynamically using env vars ---
sed -i \
  -e "s|{{ZAI_AUTH_TOKEN}}|${ZAI_AUTH_TOKEN}|g" \
  -e "s|{{KIMI_AUTH_TOKEN}}|${KIMI_AUTH_TOKEN}|g" \
  -e "s|{{DEEPSEEK_AUTH_TOKEN}}|${DEEPSEEK_AUTH_TOKEN}|g" \
  -e "s|{{QWEN_AUTH_TOKEN}}|${QWEN_AUTH_TOKEN}|g" \
  -e "s|{{OPENROUTER_API_KEY}}|${OPENROUTER_API_KEY}|g"
  ~/.codex/config.toml

# --- Run codex ---
exec codex "$@"