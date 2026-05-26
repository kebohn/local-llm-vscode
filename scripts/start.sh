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
  $COMPOSE_CMD --env-file .env up -d
else
  $COMPOSE_CMD up -d
fi

echo "Ollama is starting in background."
echo "Check status with: $COMPOSE_CMD ps"
