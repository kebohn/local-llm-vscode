# Continue Configuration for Local Ollama

## Install extension

Install Continue from VS Code marketplace:
- Extension ID: `Continue.continue`

## Apply config template

1. Copy this repository template from `.continue/config.json` into your Continue config.
2. Keep `apiBase` aligned with `.env` port.
3. Restart or reload VS Code if needed.

## Included profiles

- Fast Profile - Qwen2.5 Coder 7B
- Strong Profile - Llama 3.1 8B
- Router Profile - Local Auto (LiteLLM)

Pull both models before use:

```bash
./scripts/pull-model.sh qwen2.5-coder:7b-instruct-q4_K_M
./scripts/pull-model.sh llama3.1:8b-instruct-q4_K_M
```

Use the fast profile for autocomplete and quick edits. Use the strong profile for harder planning and refactoring tasks.

To use router profile:

1. Start router mode with `./scripts/start-router.sh`
2. Validate with `./scripts/router-health.sh`
3. In Continue, choose Router Profile - Local Auto (LiteLLM)

Router endpoint defaults:

- API base: `http://localhost:4000/v1`
- API key: `local-router-key` (set by `.env`)

Before using router profile, pull both local models:

```bash
./scripts/pull-model.sh qwen2.5-coder:7b-instruct-q4_K_M
./scripts/pull-model.sh llama3.1:8b-instruct-q4_K_M
```

For model quality/speed comparison, run:

```bash
./scripts/benchmark.sh
./scripts/benchmark.sh llama3.1:8b-instruct-q4_K_M 3
```

## Minimal config snippet

```json
{
  "models": [
    {
      "title": "Qwen2.5 Coder 7B (Local)",
      "provider": "ollama",
      "model": "qwen2.5-coder:7b-instruct-q4_K_M",
      "apiBase": "http://localhost:11434"
    }
  ]
}
```

## Alternate model examples

- `llama3.1:8b-instruct-q4_K_M`
- `codellama:7b-instruct`
- `deepseek-coder:6.7b`

After changing model names, run:

```bash
./scripts/pull-model.sh <model-tag>
```
