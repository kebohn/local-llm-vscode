#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
else
  echo "Error: Docker Compose not found."
  exit 1
fi

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env
fi

MODEL="${1:-${DEFAULT_MODEL:-qwen2.5-coder:7b-instruct-q4_K_M}}"

echo "Ensuring Ollama service is running..."
if [[ -f .env ]]; then
  $COMPOSE_CMD --env-file .env up -d ollama
else
  $COMPOSE_CMD up -d ollama
fi

echo "Pulling model: $MODEL"
$COMPOSE_CMD exec ollama ollama pull "$MODEL"

echo "Model pull completed: $MODEL"
