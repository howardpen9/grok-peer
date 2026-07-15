---
description: Spin Gemini/Antigravity peer — code task, review, or --image (agy image tool; not Grok /imagine)
argument-hint: "[--review|--image] [--out PATH] [--print-timeout 20m] [--model NAME] <task|brief>"
allowed-tools: [Bash, Read, Grep, Glob]
---

# Gemini peer (spin task)

Delegate work to local Antigravity (`agy` → Gemini family). Same product shape as `/kimi-analyze`: drop a requirement, run the peer, bring results back.

| Mode | Flag | Transport | Job |
| --- | --- | --- | --- |
| **Implement (default)** | _(none)_ | `agy -p` + YOLO skip-permissions | Coding / fix / refactor |
| **Review** | `--review` | `agy -p` only | Second-opinion code review |
| **Image** | `--image` | same YOLO path as implement | **agy `generate_image`** (Gemini image stack) |

## Image vs Grok `/imagine` (read this)

| | Grok host `/imagine` | `/gemini --image` |
| --- | --- | --- |
| Engine | **Grok Imagine** (xAI) | **Antigravity / Gemini image** via local `agy` |
| Path | Built into Grok Build | Peer spin (this plugin) |
| When | Default pictures **in Grok** | You specifically want Gemini-family image via Antigravity |

Same CLI wire (`agy`), different *intent*. Prefer host `/imagine` unless the user asked for Antigravity/Gemini image.

## Instructions

1. Resolve script:

```bash
SCRIPT="$(find "$HOME"/.grok/installed-plugins -type f -path '*/scripts/gemini-peer.sh' 2>/dev/null | xargs ls -t 2>/dev/null | head -1)"
if [ -z "${SCRIPT:-}" ]; then
  echo "grok-peer: scripts missing — reinstall plugin" >&2
  exit 1
fi
```

2. Require a task/brief. If empty after flags, ask what to do.

3. Run from the **user's project cwd**. Pass args through:

```bash
# shellcheck disable=SC2086
bash "$SCRIPT" $ARGUMENTS
```

Flags (script-parsed): `--review`, `--image` / `--img`, `--out`, `--print-timeout`, `--model`, `--add-dir`. Remaining words = prompt/brief.

### Image mode defaults

- `--out` optional; default: `$(pwd)/gemini-image.jpg` (absolute path is forced for agy).
- Script wraps the brief so agy must use `generate_image` and print `RESULT` / `PATH` / `METHOD`.
- After the run: parse stdout for `PATH:`, then `ls -la` / `file` that path. If missing, check `~/.gemini/antigravity-cli/scratch/` and report both.
- Show the image path to the user; do not claim success without a file on disk.

### Implement mode

- After run: show stdout + `git status` / `git diff`.

### Review mode

- Show peer stdout; no file edits expected.

4. Long jobs: high shell timeout or **background**. Defaults: run `20m`, review `10m`, image `10m`. stdout is plain text.

5. If `agy` missing / auth fails → install Antigravity CLI, interactive `agy` once, `/peer-setup`.

## Examples

```text
/gemini fix the failing unit tests
/gemini --review check auth for security issues
/gemini --image --out ./assets/rocket.png flat white rocket icon on navy
```

## When not to use

- Default Grok pictures → host **`/imagine`** (unless user wants Antigravity/Gemini image)
- Cheap bulk tree reading → `/kimi-analyze`
- Codex-shaped diff review → `/codex-review`

## Aliases

`/agy-run` ≈ `/gemini` · `/agy-review` ≈ `/gemini --review`

User arguments: $ARGUMENTS
