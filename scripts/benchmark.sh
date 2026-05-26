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
RUNS="${2:-5}"
PROMPT="${BENCH_PROMPT:-Write one short sentence that confirms benchmarking works.}"

echo "Benchmarking model: ${MODEL}"
echo "Runs: ${RUNS}"
echo

python - "$PORT" "$MODEL" "$RUNS" "$PROMPT" <<'PY'
import json
import statistics
import sys
import time
import urllib.error
import urllib.request

port, model, runs, prompt = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]
url = f"http://localhost:{port}/api/generate"

def run_once() -> tuple[float, int]:
    payload = {
        "model": model,
        "prompt": prompt,
        "stream": False,
        "options": {"temperature": 0}
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"})
    t0 = time.perf_counter()
    with urllib.request.urlopen(req, timeout=600) as resp:
        body = json.loads(resp.read().decode("utf-8"))
    dt = time.perf_counter() - t0
    eval_count = int(body.get("eval_count") or 0)
    return dt, eval_count

samples = []
for i in range(1, runs + 1):
    try:
        dt, tokens = run_once()
        tps = tokens / dt if dt > 0 else 0.0
        samples.append((dt, tokens, tps))
        print(f"run {i}: {dt:.2f}s, tokens={tokens}, tokens/s={tps:.2f}")
    except urllib.error.HTTPError as e:
        print(f"run {i}: HTTP error {e.code}: {e.read().decode('utf-8', errors='ignore')}")
        sys.exit(1)
    except Exception as e:
        print(f"run {i}: error: {e}")
        sys.exit(1)

latencies = [s[0] for s in samples]
tps_vals = [s[2] for s in samples]
print("\nsummary")
print(f"latency avg/min/max: {statistics.mean(latencies):.2f}s / {min(latencies):.2f}s / {max(latencies):.2f}s")
print(f"tokens/s avg/min/max: {statistics.mean(tps_vals):.2f} / {min(tps_vals):.2f} / {max(tps_vals):.2f}")
PY
