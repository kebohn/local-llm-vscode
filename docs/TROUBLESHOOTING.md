# Troubleshooting

## Docker daemon not running

Symptoms:
- `./scripts/setup.sh` fails with Docker daemon errors.

Fix:
1. Start Docker Engine or Docker Desktop.
2. Run `docker info` and verify it returns details.
3. Retry `./scripts/setup.sh`.

## Port 11434 already in use

Symptoms:
- `./scripts/start.sh` reports bind/address-in-use errors.

Fix:
1. Edit `.env` and set a different port, for example `OLLAMA_PORT=11500`.
2. Restart with `./scripts/stop.sh && ./scripts/start.sh`.
3. Update Continue API base URL to the new port.

## Model pull is very slow

Symptoms:
- `./scripts/pull-model.sh` takes a long time.

Fix:
1. Check internet stability.
2. Use a smaller model tag.
3. Keep models cached in the Docker volume; future pulls are faster.

## Health script fails on generate

Symptoms:
- `./scripts/health.sh` can list tags but generate fails.

Fix:
1. Confirm the selected model exists in `ollama list` output.
2. Pull the model explicitly, for example:
   `./scripts/pull-model.sh qwen2.5-coder:7b-instruct-q4_K_M`
3. Rerun `./scripts/health.sh`.

## Continue cannot connect

Symptoms:
- Continue shows connection errors.

Fix:
1. Verify Ollama endpoint: `curl http://localhost:11434/api/tags`.
2. Confirm Continue `apiBase` is correct.
3. Reload VS Code window after changing Continue config.
4. Ensure no proxy/firewall blocks localhost traffic.
