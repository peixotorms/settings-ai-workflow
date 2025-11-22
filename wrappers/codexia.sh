#!/bin/bash
export OPENAI_API_BASE="https://api.openai.com/v1"
export OPENAI_API_KEY="{{OPENAI_API_KEY}}"
exec codex -m gpt-5.1-codex-max -c model_reasoning_effort="xhigh" --search --sandbox workspace-write --ask-for-approval on-failure "$@"