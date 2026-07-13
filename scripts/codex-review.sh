#!/usr/bin/env bash
# Run Codex non-interactive review against this repo.
# Usage:
#   codex-review.sh [--base REF] [--adversarial] [extra focus text...]
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

BASE=""
ADVERSARIAL=0
FOCUS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      BASE="${2:-}"
      [[ -n "$BASE" ]] || peer_die "--base requires a ref"
      shift 2
      ;;
    --adversarial)
      ADVERSARIAL=1
      shift
      ;;
    --)
      shift
      FOCUS+=("$@")
      break
      ;;
    *)
      FOCUS+=("$1")
      shift
      ;;
  esac
done

CODEX="$(peer_resolve_bin codex CODEX_BIN)" || peer_die "codex not found. Install Codex CLI and run: codex login"

ARGS=(review)
if [[ -n "$BASE" ]]; then
  ARGS+=(--base "$BASE")
else
  ARGS+=(--uncommitted)
fi

PROMPT=""
if [[ "$ADVERSARIAL" -eq 1 ]]; then
  PROMPT="Adversarial review. Challenge design choices, failure modes, races, security, and simpler alternatives. Be specific about file paths and severity."
fi
if [[ ${#FOCUS[@]} -gt 0 ]]; then
  if [[ -n "$PROMPT" ]]; then
    PROMPT="$PROMPT Focus also on: ${FOCUS[*]}"
  else
    PROMPT="${FOCUS[*]}"
  fi
fi

echo "grok-peer: running codex ${ARGS[*]}" >&2
if [[ -n "$PROMPT" ]]; then
  exec "$CODEX" "${ARGS[@]}" "$PROMPT"
else
  exec "$CODEX" "${ARGS[@]}"
fi
