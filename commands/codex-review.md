---
description: Peer review via local Codex CLI (read-only) — like Claude's /codex:review
argument-hint: "[--base <ref>] [focus text]"
allowed-tools: [Bash, Read, Grep, Glob]
---

# Codex review (peer)

Run a **read-only** Codex review of the current work. Do not re-implement the review yourself first — call the peer.

## Instructions

1. Resolve script (name-scoped):

```bash
SCRIPT="$(ls -1 "$HOME"/.grok/installed-plugins/grok-peer*/scripts/codex-review.sh 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: scripts missing — reinstall plugin" >&2
  exit 1
fi
```

2. Run from the **user's project cwd**. Pass user args safely as separate words from `$ARGUMENTS` (do not invent flags). Prefer:

```bash
# shellcheck disable=SC2086
bash "$SCRIPT" $ARGUMENTS
```

If `$ARGUMENTS` is empty:

```bash
bash "$SCRIPT"
```

3. Return Codex's full output. Summarize only if asked.
4. If `codex` is missing, stop and tell them to run `/peer-setup`.

## Notes

- Default: uncommitted changes.
- Branch: `/codex-review --base main`
- Peer call — another model, not Grok self-review.

User arguments: $ARGUMENTS
