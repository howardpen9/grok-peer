---
description: Bulk codebase analysis via local Kimi CLI — cheap long-context reader peer
argument-hint: "[--detail summary|normal|detailed] [query]"
allowed-tools: [Bash, Read, Grep, Glob]
---

# Kimi analyze (peer)

Delegate heavy reading to Kimi. Prefer Kimi's summary over reading dozens of files yourself.

## Instructions

Default `--detail` is `summary` unless the user asks for more. Work dir = `pwd`.

```bash
SCRIPT="$(ls -1 "$HOME"/.grok/installed-plugins/grok-peer*/scripts/kimi-analyze.sh 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: scripts missing — reinstall plugin" >&2
  exit 1
fi
# shellcheck disable=SC2086
bash "$SCRIPT" --work-dir "$(pwd)" $ARGUMENTS
```

Present Kimi's report, then do **targeted** reads/edits only. If `kimi` is missing → `/peer-setup`.

## When to use

- Unfamiliar / large codebase orientation
- Architecture or dependency maps
- Sweeps before editing

## When not to use

- Single-file fixes
- User already pasted the relevant code

User arguments: $ARGUMENTS
