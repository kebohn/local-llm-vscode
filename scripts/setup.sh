#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not in PATH."
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
else
  echo "Error: Docker Compose not found. Install docker compose plugin or docker-compose."
  exit 1
fi

echo "Using compose command: $COMPOSE_CMD"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
else
  echo ".env already exists, keeping existing values"
fi

if ! docker info >/dev/null 2>&1; then
  echo "Error: Docker daemon is not reachable. Start Docker and retry."
  exit 1
fi

echo "Setup completed successfully."
echo "Next steps:"
echo "1) ./scripts/start.sh"
echo "2) ./scripts/pull-model.sh"
echo "3) ./scripts/health.sh"
