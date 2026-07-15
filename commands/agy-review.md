---
description: Alias of /gemini --review — Antigravity LLM review (no skip-permissions)
argument-hint: "[--print-timeout 10m] [--model NAME] [focus text]"
allowed-tools: [Bash, Read, Grep, Glob]
---

# `/agy-review` → prefer **`/gemini --review`**

Same transport. Prefer **`/gemini --review <focus>`**.

```bash
SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/gemini-peer.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/agy-review.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
  # shellcheck disable=SC2086
  bash "$SCRIPT" $ARGUMENTS
  exit $?
fi
# shellcheck disable=SC2086
bash "$SCRIPT" --review $ARGUMENTS
```

If empty args, default review prompt applies via the script chain.

**Not image gen.**

User arguments: $ARGUMENTS
