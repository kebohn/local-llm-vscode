#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
fi

PORT="${LITELLM_PORT:-4000}"
KEY="${LITELLM_MASTER_KEY:-local-router-key}"

echo "Checking LiteLLM router models endpoint on port $PORT..."
curl -fsS "http://localhost:${PORT}/v1/models" \
  -H "Authorization: Bearer ${KEY}" \
  >/tmp/litellm-models.json

echo "OK: router is reachable"
if command -v jq >/dev/null 2>&1; then
  echo "Available router models:"
  jq -r '.data[].id' /tmp/litellm-models.json || true
else
  cat /tmp/litellm-models.json
fi
