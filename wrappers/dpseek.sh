#!/bin/bash
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="{{DEEPSEEK_AUTH_TOKEN}}"
export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-chat"
export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-chat"
export ANTHROPIC_MODEL="deepseek-chat"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-chat"
export ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export MAX_THINKING_TOKENS=32000
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"

# Only Web Search Prime MCP if not already installed
if ! claude mcp list 2>/dev/null | grep -q '^web-search-prime'; then
  claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp \
    --header "Authorization: {{ZAI_AUTH_TOKEN}}" 2>/dev/null
fi

# Only add Perplexity MCP if not already installed
if ! claude mcp list 2>/dev/null | grep -q '^perplexity-mcp'; then
  claude mcp add -s user -t stdio perplexity-mcp --env PERPLEXITY_API_KEY="{{PERPLEXITY_API_KEY}}" -- npx -y perplexity-mcp 2>/dev/null
fi

# Only add Codex MCP if not already installed
if ! claude mcp list 2>/dev/null | grep -q '^codex'; then
  claude mcp add codex -s user -- codex -m gpt-5 -c model_reasoning_effort="high" mcp-server 2>/dev/null
fi

# Only add Cognition Wheel Extended MCP if not already installed (suppress EPIPE errors)
if ! claude mcp list 2>/dev/null | grep -q '^cognition-wheel-extended'; then
  claude mcp add cognition-wheel-extended -s user \
    -e OPENAI_API_KEY="{{OPENAI_API_KEY}}" \
    -e OPENAI_MODEL="gpt-5" \
    -e OPENAI_REASONING_EFFORT="high" \
    -e DEEPSEEK_API_KEY="{{DEEPSEEK_AUTH_TOKEN}}" \
    -e DEEPSEEK_MODEL="deepseek-chat" \
    -e OPENROUTER_API_KEY="{{OPENROUTER_API_KEY}}" \
    -e OPENROUTER_MODELS="qwen/qwen3-coder,moonshotai/kimi-k2-0905" \
    -e ZAI_API_KEY="{{ZAI_AUTH_TOKEN}}" \
    -e ZAI_MODEL="glm-4.6" \
    -- npx -y mcp-cognition-wheel-extended 2>/dev/null
fi

# Replace shell with Claude
exec claude "$@"