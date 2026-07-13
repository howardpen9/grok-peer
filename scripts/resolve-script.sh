#!/usr/bin/env bash
# Print absolute path to a script inside this plugin: resolve-script.sh <name>
# e.g. resolve-script.sh peer-setup.sh
set -euo pipefail
NAME="${1:?usage: resolve-script.sh <script-name>}"

# 1) Same directory as this helper (always works when invoked from package scripts/)
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SELF_DIR/$NAME" ]]; then
  echo "$SELF_DIR/$NAME"
  exit 0
fi

# 2) Name-scoped installed-plugins (Grok copies plugin under ~/.grok/installed-plugins/grok-peer-*)
CAND="$(ls -1 "$HOME"/.grok/installed-plugins/grok-peer*/scripts/"$NAME" 2>/dev/null | head -1 || true)"
if [[ -n "${CAND:-}" && -f "$CAND" ]]; then
  echo "$CAND"
  exit 0
fi

# 3) Any grok-peer install path
CAND="$(find "$HOME"/.grok/installed-plugins -path '*/grok-peer*/scripts/'"$NAME" 2>/dev/null | head -1 || true)"
if [[ -n "${CAND:-}" && -f "$CAND" ]]; then
  echo "$CAND"
  exit 0
fi

echo "grok-peer: cannot find scripts/$NAME (reinstall plugin: grok plugin install <path> --trust)" >&2
exit 1
