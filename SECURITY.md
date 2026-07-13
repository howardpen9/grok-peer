# Security

## What this plugin does

`grok-peer` is a **Grok Build plugin** that adds slash commands. Those commands instruct the agent to run **local shell scripts** under `scripts/`. The scripts only:

1. Resolve `codex` / `kimi` / optional `claude` on `PATH` (or `CODEX_BIN` / `KIMI_BIN` / `CLAUDE_BIN`).
2. Invoke those CLIs with review / analyze arguments.
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

You must already trust and have installed those CLIs. This plugin does not replace their auth models.

## Permissions surface

- Slash commands request `Bash` / `Read` / `Grep` / `Glob` so Grok can run the scripts and inspect results.
- Scripts exit non-zero if a peer binary is missing — they do not silently fall back to remote installs.

## Reporting issues

Open an issue on the repository homepage listed in `.grok-plugin/plugin.json`.
