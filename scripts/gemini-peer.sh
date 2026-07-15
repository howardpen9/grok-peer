#!/usr/bin/env bash
# Unified Gemini peer entry (product: /gemini).
# Transport: Antigravity CLI `agy` (Gemini-family coding + optional image tools).
#
# Usage:
#   gemini-peer.sh [--review] [--image] [--out PATH] [--print-timeout DURATION]
#                  [--model NAME] [--add-dir PATH]... [task...]
#
# Modes:
#   (default)  implement coding task with --dangerously-skip-permissions
#   --review   read-only peer review (no skip-permissions)
#   --image    spin agy to generate an image via its generate_image tool
#              (same YOLO transport as implement; not Grok host /imagine)
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

MODE="run"
OUT=""
PRINT_TIMEOUT=""
MODEL=""
ADD_DIRS=()
PROMPT_PARTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --review)
      MODE="review"
      shift
      ;;
    --image|--img)
      MODE="image"
      shift
      ;;
    --run|--implement)
      MODE="run"
      shift
      ;;
    --out)
      OUT="${2:-}"
      [[ -n "$OUT" ]] || peer_die "--out requires a path"
      shift 2
      ;;
    --print-timeout)
      PRINT_TIMEOUT="${2:-}"
      [[ -n "$PRINT_TIMEOUT" ]] || peer_die "--print-timeout requires a duration (e.g. 10m)"
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

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

forward_common=()
if [[ -n "$PRINT_TIMEOUT" ]]; then
  forward_common+=(--print-timeout "$PRINT_TIMEOUT")
fi
if [[ -n "$MODEL" ]]; then
  forward_common+=(--model "$MODEL")
fi
for d in "${ADD_DIRS[@]+"${ADD_DIRS[@]}"}"; do
  forward_common+=(--add-dir "$d")
done

case "$MODE" in
  review)
    exec bash "$SELF/agy-review.sh" \
      "${forward_common[@]+"${forward_common[@]}"}" \
      "${PROMPT_PARTS[@]+"${PROMPT_PARTS[@]}"}"
    ;;
  run)
    exec bash "$SELF/agy-run.sh" \
      "${forward_common[@]+"${forward_common[@]}"}" \
      "${PROMPT_PARTS[@]+"${PROMPT_PARTS[@]}"}"
    ;;
  image)
    BRIEF="${PROMPT_PARTS[*]:-}"
    if [[ -z "$BRIEF" ]]; then
      peer_die "image mode needs a brief. Example: /gemini --image --out ./icon.png a flat rocket icon on navy"
    fi
    if [[ -z "$OUT" ]]; then
      OUT="$(pwd)/gemini-image.jpg"
    fi
    # Resolve to absolute path for the peer (agy often ignores relative cwd).
    if [[ "$OUT" != /* ]]; then
      OUT="$(pwd)/$OUT"
    fi
    mkdir -p "$(dirname "$OUT")"
    if [[ -z "$PRINT_TIMEOUT" ]]; then
      forward_common+=(--print-timeout "10m")
    fi

    IMAGE_PROMPT="You are an image worker inside Antigravity. Use your generate_image tool (Gemini / Nano Banana image stack). Do not write application code unless needed to save/copy the file.

User brief:
$BRIEF

Hard requirements:
1. Generate exactly ONE image matching the brief.
2. Save the final image to this absolute path:
   $OUT
   Prefer the extension in that path (.jpg / .png). If the tool only writes elsewhere (e.g. scratch or brain/), copy or move the result to the path above.
3. Do not modify unrelated project files.
4. End your reply with these exact lines (no markdown fences):
RESULT: ok|fail
PATH: <absolute path that exists on disk>
METHOD: generate_image|fallback|fail
SIZE: <bytes if known, else unknown>
"

    echo "grok-peer: /gemini --image via agy (not Grok /imagine) out=$OUT" >&2
    exec bash "$SELF/agy-run.sh" \
      "${forward_common[@]+"${forward_common[@]}"}" \
      "$IMAGE_PROMPT"
    ;;
  *)
    peer_die "unknown mode: $MODE"
    ;;
esac
