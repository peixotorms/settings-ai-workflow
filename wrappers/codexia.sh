#!/bin/bash
set -e

# =============================================================================
# API Keys Configuration - Define once, use everywhere
# =============================================================================
OPENAI_API_KEY_VALUE="{{OPENAI_API_KEY}}"
ZAI_AUTH_TOKEN_VALUE="{{ZAI_AUTH_TOKEN}}"
KIMI_AUTH_TOKEN_VALUE="{{KIMI_AUTH_TOKEN}}"
DEEPSEEK_AUTH_TOKEN_VALUE="{{DEEPSEEK_AUTH_TOKEN}}"
QWEN_AUTH_TOKEN_VALUE="{{QWEN_AUTH_TOKEN}}"
OPENROUTER_API_KEY_VALUE="{{OPENROUTER_API_KEY}}"

# =============================================================================
# Environment setup - Export the defined keys
# =============================================================================
export OPENAI_API_BASE="https://api.openai.com/v1"
export OPENAI_API_KEY="${OPENAI_API_KEY_VALUE}"
export ZAI_AUTH_TOKEN="${ZAI_AUTH_TOKEN_VALUE}"
export KIMI_AUTH_TOKEN="${KIMI_AUTH_TOKEN_VALUE}"
export DEEPSEEK_AUTH_TOKEN="${DEEPSEEK_AUTH_TOKEN_VALUE}"
export QWEN_AUTH_TOKEN="${QWEN_AUTH_TOKEN_VALUE}"
export OPENROUTER_API_KEY="${OPENROUTER_API_KEY_VALUE}"

# =============================================================================
# Per-user config directory setup
# =============================================================================
CONFIG_DIR="${HOME}/.codex"
mkdir -p "$CONFIG_DIR"

# =============================================================================
# Download fresh TOML template and replace placeholders
# =============================================================================
curl -H "Cache-Control: no-cache" -fsSL "https://raw.githubusercontent.com/peixotorms/settings-ai-workflow/main/settings/codex/config.toml" -o "$CONFIG_DIR/config.toml"
chmod 600 "$CONFIG_DIR/config.toml"

# Replace placeholders with actual API keys using the centralized variables
# Note: TOML uses __PLACEHOLDER__ syntax to avoid conflicts with installer
sed -i \
  -e "s|__ZAI_AUTH_TOKEN__|${ZAI_AUTH_TOKEN_VALUE}|g" \
  -e "s|__KIMI_AUTH_TOKEN__|${KIMI_AUTH_TOKEN_VALUE}|g" \
  -e "s|__DEEPSEEK_AUTH_TOKEN__|${DEEPSEEK_AUTH_TOKEN_VALUE}|g" \
  -e "s|__QWEN_AUTH_TOKEN__|${QWEN_AUTH_TOKEN_VALUE}|g" \
  -e "s|__OPENROUTER_API_KEY__|${OPENROUTER_API_KEY_VALUE}|g" \
  -e "s|__OPENAI_API_KEY__|${OPENAI_API_KEY_VALUE}|g" \
  "$CONFIG_DIR/config.toml"

# =============================================================================
# Run codex with the prepared config
# =============================================================================
exec codex "$@"
