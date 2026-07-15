---
description: Check peer CLIs (Codex, Kimi, agy) ready for /codex-*, /kimi-analyze, /gemini
argument-hint: ""
allowed-tools: [Bash, Read]
---

# Peer setup

Verify local peer tooling for Grok Build (Codex, Kimi, Antigravity/`agy`).

## Instructions

1. Resolve and run `peer-setup.sh` (newest install — `grok-peer-*` or hash local dirs):

```bash
SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/peer-setup.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: plugin scripts not found. Reinstall: grok plugin install <source> --trust" >&2
  exit 1
fi
bash "$SCRIPT"
```

2. Show full stdout/stderr to the user.
3. If anything is `MISS`, give the shortest install/login fix for that peer only.

User arguments: $ARGUMENTS
