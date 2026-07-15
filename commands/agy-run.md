---
description: Alias of /gemini (implement) — Antigravity LLM task with skip-permissions
argument-hint: "[--print-timeout 20m] [--model NAME] <task prompt>"
allowed-tools: [Bash, Read, Grep, Glob]
---

# `/agy-run` → prefer **`/gemini`**

Same transport. Prefer the product name **`/gemini <task>`**.

```bash
SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/gemini-peer.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  # fallback to legacy runner
  SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/agy-run.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
fi
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: scripts missing — reinstall plugin" >&2
  exit 1
fi
# shellcheck disable=SC2086
bash "$SCRIPT" $ARGUMENTS
```

Require a task prompt. After completion: show stdout + `git status` / `git diff`.

**Not image gen.** Pictures → host `/imagine`.

User arguments: $ARGUMENTS
