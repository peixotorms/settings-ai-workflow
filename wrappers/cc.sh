#!/bin/bash
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export MAX_THINKING_TOKENS=32000
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"

# Remove all existing MCP servers from both scopes
mcp_list=$(claude mcp list 2>/dev/null | grep -E '^\w' | awk -F: '{print $1}')
for mcp_server in $mcp_list; do
  claude mcp remove "$mcp_server" -s local 2>/dev/null
  claude mcp remove "$mcp_server" -s user 2>/dev/null
done

# Add Web Search Prime MCP
claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp \
  --header "Authorization: {{ZAI_AUTH_TOKEN}}"

# Add Codex MCP
claude mcp add codex -s user -- codex -m gpt-5 -c model_reasoning_effort="high" mcp-server

# Add Cognition Wheel Extended MCP
claude mcp add cognition-wheel-extended -s user \
  -e OPENAI_API_KEY="{{OPENAI_API_KEY}}" \
  -e OPENAI_MODEL="gpt-5.1" \
  -e OPENAI_REASONING_EFFORT="high" \
  -e DEEPSEEK_API_KEY="{{DEEPSEEK_AUTH_TOKEN}}" \
  -e DEEPSEEK_MODEL="deepseek-chat" \
  -e OPENROUTER_API_KEY="{{OPENROUTER_API_KEY}}" \
  -e OPENROUTER_MODELS="qwen/qwen3-coder,moonshotai/kimi-k2-0905" \
  -e ZAI_API_KEY="{{ZAI_AUTH_TOKEN}}" \
  -e ZAI_MODEL="glm-4.6" \
  -- npx -y mcp-cognition-wheel-extended

# Replace shell with Claude
exec claude "$@"