#!/usr/bin/env bash
# Run Kimi non-interactive analysis on a work dir.
# Usage:
#   kimi-analyze.sh [--work-dir PATH] [--detail summary|normal|detailed] [query...]
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

WORK_DIR="$(pwd)"
DETAIL="summary"
QUERY_PARTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --work-dir)
      WORK_DIR="${2:-}"
      [[ -n "$WORK_DIR" ]] || peer_die "--work-dir requires a path"
      shift 2
      ;;
    --detail)
      DETAIL="${2:-}"
      shift 2
      ;;
    *)
      QUERY_PARTS+=("$1")
      shift
      ;;
  esac
done

KIMI="$(peer_resolve_bin kimi KIMI_BIN)" || peer_die "kimi not found. Install Kimi Code CLI and run: kimi login"

QUERY="${QUERY_PARTS[*]:-}"
if [[ -z "$QUERY" ]]; then
  QUERY="Summarize this codebase: architecture, main modules, risks, and where a new contributor should start."
fi

case "$DETAIL" in
  summary|normal|detailed) ;;
  *) peer_die "--detail must be summary|normal|detailed" ;;
esac

# Prompt-side verbosity control (kimi CLI has no detail_level flag).
DETAIL_INSTR=""
case "$DETAIL" in
  summary)
    DETAIL_INSTR="Respond in a tight summary: bullets only, no long code blocks, max ~40 lines."
    ;;
  normal)
    DETAIL_INSTR="Respond with clear structure and only the most important file paths."
    ;;
  detailed)
    DETAIL_INSTR="Respond in detail with key file paths and short snippets where useful."
    ;;
esac

FULL_PROMPT="$DETAIL_INSTR

Task:
$QUERY

Working directory: $WORK_DIR
Read the repository as needed. Do not modify files."

echo "grok-peer: kimi analyze work_dir=$WORK_DIR detail=$DETAIL" >&2

# kimi -p: one-shot non-interactive
# Prefer --work-dir if supported; else -w / cd.
if "$KIMI" --help 2>&1 | grep -qE -- '--work-dir|-w'; then
  if "$KIMI" --help 2>&1 | grep -q -- '--work-dir'; then
    exec "$KIMI" --work-dir "$WORK_DIR" -p "$FULL_PROMPT" --output-format text
  else
    exec "$KIMI" -w "$WORK_DIR" -p "$FULL_PROMPT" --output-format text
  fi
else
  cd "$WORK_DIR"
  exec "$KIMI" -p "$FULL_PROMPT" --output-format text
fi
