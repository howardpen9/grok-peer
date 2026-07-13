---
description: Adversarial peer review via Codex — challenge design, races, security
argument-hint: "[--base <ref>] [risk focus]"
allowed-tools: [Bash, Read, Grep, Glob]
---

# Codex adversarial review (peer)

Pressure-test the current change with Codex. Read-only.

## Instructions

```bash
SCRIPT="$(ls -1 "$HOME"/.grok/installed-plugins/grok-peer*/scripts/codex-review.sh 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: scripts missing — reinstall plugin" >&2
  exit 1
fi
# shellcheck disable=SC2086
bash "$SCRIPT" --adversarial $ARGUMENTS
```

Return the peer output. Highlight Critical/High items if long. Do not apply fixes unless the user asks after the review.

User arguments: $ARGUMENTS
