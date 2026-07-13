---
description: Check that peer CLIs (Codex, Kimi) are installed and ready for /codex-* and /kimi-analyze
argument-hint: ""
allowed-tools: [Bash, Read]
---

# Peer setup

Verify local peer tooling for Grok Build.

## Instructions

1. Resolve and run `peer-setup.sh` (name-scoped install path only — no personal machine paths):

```bash
SCRIPT="$(ls -1 "$HOME"/.grok/installed-plugins/grok-peer*/scripts/peer-setup.sh 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: plugin scripts not found. Reinstall: grok plugin install <source> --trust" >&2
  exit 1
fi
bash "$SCRIPT"
```

2. Show full stdout/stderr to the user.
3. If anything is `MISS`, give the shortest install/login fix for that peer only.

User arguments: $ARGUMENTS
