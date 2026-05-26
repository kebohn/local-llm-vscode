#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
fi

PORT="${OLLAMA_PORT:-11434}"
MODEL="${1:-${DEFAULT_MODEL:-qwen2.5-coder:7b-instruct-q4_K_M}}"

echo "Checking Ollama tags endpoint on port $PORT..."
curl -fsS "http://localhost:${PORT}/api/tags" >/tmp/ollama-tags.json
echo "OK: /api/tags is reachable"

if command -v jq >/dev/null 2>&1; then
  echo "Available models:"
  jq -r '.models[].name' /tmp/ollama-tags.json || true
else
  echo "Install jq to see formatted model list."
fi

echo "Running sample prompt on model: $MODEL"
curl -fsS "http://localhost:${PORT}/api/generate" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${MODEL}\",\"prompt\":\"Reply with only: local-llm-ready\",\"stream\":false}" \
  >/tmp/ollama-generate.json

if command -v jq >/dev/null 2>&1; then
  echo "Model response:"
  jq -r '.response' /tmp/ollama-generate.json
else
  cat /tmp/ollama-generate.json
fi

echo "Health check completed."
