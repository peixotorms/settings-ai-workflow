#!/bin/bash
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
export ANTHROPIC_AUTH_TOKEN="{{ZAI_AUTH_TOKEN}}"
export ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.6"
export ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6"
export ANTHROPIC_MODEL="glm-4.5"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"
export ANTHROPIC_SMALL_FAST_MODEL="glm-4.5-air"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export MAX_THINKING_TOKENS=32000
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"

is_server_connected() {
  local name="$1"
  local scope="$2"
  local list_output line

  if ! list_output=$(claude mcp list -s "$scope" 2>/dev/null); then
    list_output=$(claude mcp list 2>/dev/null || true)
  fi

  line=$(printf '%s\n' "$list_output" | awk -v n="$name" '$1==n {print; exit}')
  [[ -n "$line" ]] && grep -qiE 'connected|active' <<<"$line"
}

ensure_mcp_server() {
  local name="$1"
  local scope="$2"
  shift 2
  local add_cmd=("$@")

  if is_server_connected "$name" "$scope"; then
    echo "[INFO] MCP server '$name' already active in '$scope' scope."
    return
  fi

  echo "[INFO] Reinstalling MCP server '$name'..."
  for target_scope in local user; do
    claude mcp remove "$name" -s "$target_scope" >/dev/null 2>&1 || true
  done

  "${add_cmd[@]}"
}

ensure_mcp_server "web-search-prime" "user" \
  claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp \
    --header "Authorization: {{ZAI_AUTH_TOKEN}}"

ensure_mcp_server "codex" "user" \
  claude mcp add codex -s user -- codex -m gpt-5 -c model_reasoning_effort="high" mcp-server

ensure_mcp_server "cognition-wheel-extended" "user" \
  claude mcp add cognition-wheelextended -s user \
    -e OPENAI_API_KEY="{{OPENAI_API_KEY}}" \
    -e OPENAI_MODEL="gpt-5.1" \
    -e OPENAI_REASONING_EFFORT="high" \
    -e DEEPSEEK_API_KEY="{{DEEPSEEK_AUTH_TOKEN}}" \
    -e DEEPSEEK_MODEL="deepseek-chat" \
    -e OPENROUTER_API_KEY="{{OPENROUTER_API_KEY}}" \
    -e OPENROUTER_MODELS="qwen/qwen3-coder,moonshotai/kimi-k2-thinking" \
    -- npx -y mcp-cognition-wheel-extended

# Replace shell with Claude
exec claude "$@"