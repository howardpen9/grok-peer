#!/usr/bin/env bash
# Run Antigravity CLI (agy) non-interactive implement path WITH --dangerously-skip-permissions.
# Usage:
#   agy-run.sh [--print-timeout DURATION] [--model NAME] [--add-dir PATH]... [prompt...]
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

PRINT_TIMEOUT="20m"
MODEL=""
ADD_DIRS=()
PROMPT_PARTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --print-timeout)
      PRINT_TIMEOUT="${2:-}"
      [[ -n "$PRINT_TIMEOUT" ]] || peer_die "--print-timeout requires a duration (e.g. 20m)"
      shift 2
      ;;
    --model)
      MODEL="${2:-}"
      [[ -n "$MODEL" ]] || peer_die "--model requires a name"
      shift 2
      ;;
    --add-dir)
      [[ -n "${2:-}" ]] || peer_die "--add-dir requires a path"
      ADD_DIRS+=("$2")
      shift 2
      ;;
    --)
      shift
      PROMPT_PARTS+=("$@")
      break
      ;;
    *)
      PROMPT_PARTS+=("$1")
      shift
      ;;
  esac
done

AGY="$(peer_resolve_bin agy AGY_BIN)" || peer_die "agy not found. Install Antigravity CLI and sign in (run: agy). Optional: export AGY_BIN=/path/to/agy"

PROMPT="${PROMPT_PARTS[*]:-}"
if [[ -z "$PROMPT" ]]; then
  peer_die "gemini peer requires a task prompt. Example: /gemini fix the failing test in foo_test.go"
fi

ARGS=(
  -p "$PROMPT"
  --dangerously-skip-permissions
  --print-timeout "$PRINT_TIMEOUT"
)
if [[ -n "$MODEL" ]]; then
  ARGS+=(--model "$MODEL")
fi
for d in "${ADD_DIRS[@]+"${ADD_DIRS[@]}"}"; do
  ARGS+=(--add-dir "$d")
done

echo "grok-peer: agy run --dangerously-skip-permissions timeout=$PRINT_TIMEOUT cwd=$(pwd)" >&2
echo "grok-peer: WARNING — agy will auto-approve its own tool calls (edits/shell)." >&2
# Plain text only. Bound by --print-timeout (default 20m for implement).
exec "$AGY" "${ARGS[@]}"
