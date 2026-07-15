# Security

## What this plugin does

`grok-peer` is a **Grok Build plugin** that adds slash commands. Those commands instruct the agent to run **local shell scripts** under `scripts/`. The scripts only:

1. Resolve `codex` / `kimi` / `agy` / optional `claude` on `PATH` (or `CODEX_BIN` / `KIMI_BIN` / `AGY_BIN` / `CLAUDE_BIN`).
2. Invoke those CLIs with review / analyze / run arguments.
3. Print stdout/stderr back to the terminal.

## What this plugin does **not** do

- No `curl | bash` or remote binary download
- No `postinstall` network install
- No reading `~/.ssh`, browser cookies, or unrelated `.env` files
- No sending your code or tokens to a third-party server operated by this plugin
- No hidden telemetry

## Network & credentials

| Component | Network | Credentials |
| --- | --- | --- |
| This plugin’s scripts | None by themselves | None |
| **Codex CLI** (when you run `/codex-*`) | Whatever OpenAI / your Codex config uses | Your existing `codex login` / API setup |
| **Kimi CLI** (when you run `/kimi-analyze`) | Whatever Moonshot / Kimi Code uses | Your existing `kimi login` or API key env |
| **Antigravity CLI** (`agy`, when you run `/gemini` or `/agy-*`) | Whatever Google / Antigravity uses | Your existing `agy` sign-in (OS keyring / browser) |

You must already trust and have installed those CLIs. This plugin does not replace their auth models.

## `/gemini` (and `/agy-run`) + `--dangerously-skip-permissions`

`/gemini` (default implement mode), `/gemini --image`, and `/agy-run` pass `--dangerously-skip-permissions` so Antigravity auto-approves **its own** tool calls (edits, shell, and agy’s image tool when used) without interactive prompts. High-trust peer path:

- Prefer `/gemini --review` (or `/agy-review`) for second opinions (no skip flag).
- Prefer a clean branch or git worktree for unsupervised implement.
- Do not feed untrusted prompts into implement / image mode.
- **Two media stacks:** Grok host `/imagine` = Grok Imagine (xAI). `/gemini --image` = Antigravity’s `generate_image` (Gemini image) via local `agy` — same peer wire, different engine. Default in-Grok pictures should stay on `/imagine` unless the user asks for Antigravity/Gemini image.

## Permissions surface

- Slash commands request `Bash` / `Read` / `Grep` / `Glob` so Grok can run the scripts and inspect results.
- Scripts exit non-zero if a peer binary is missing — they do not silently fall back to remote installs.

## Reporting issues

Open an issue on the repository homepage listed in `.grok-plugin/plugin.json`.
