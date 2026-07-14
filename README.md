# grok-peer

<!-- social preview: assets/social-preview.png -->
<p align="center">
  <img src="assets/social-preview.png" alt="grok-peer — Peer slash commands for Grok Build" width="100%" />
</p>

<p align="center">
  <strong>Peer slash for <a href="https://x.ai/cli">Grok Build</a></strong><br/>
  Call local <strong>Codex</strong> &amp; <strong>Kimi</strong> without leaving Grok — the missing edge when Grok is the conductor.
</p>

<p align="center">
  <a href="https://github.com/howardpen9/grok-peer/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT" /></a>
  <a href="https://github.com/xai-org/plugin-marketplace/pull/84"><img src="https://img.shields.io/badge/xAI%20marketplace-PR%20%2384-black" alt="marketplace PR" /></a>
  <img src="https://img.shields.io/badge/host-Grok%20Build-brightgreen" alt="Grok Build" />
</p>

---

## Why this exists

In 2026 most machines run **several** coding agents at once — Claude Code, Codex, Grok Build, Kimi, Cursor… each with its own login and quota.

The ecosystem already solved **one direction** well: **Claude as main**, other models as peers.

| Direction (main → peer) | Example | Status |
| --- | --- | --- |
| **Claude → Codex** | Official [`openai/codex-plugin-cc`](https://github.com/openai/codex-plugin-cc) (`/codex:review`, …) | ✅ Product-grade |
| **Claude → Grok** | Community plugins (e.g. Claude↔Grok review / search wrappers) | ✅ Common |
| **Claude → Kimi** | [`kimi-code-mcp`](https://github.com/howardpen9/kimi-code-mcp) as MCP tools | ✅ Transport ready |
| **Codex → Grok / others** | Codex plugins / MCP bridges | △ Exists, uneven |
| **Grok → Codex** | — | ❌ Thin / empty |
| **Grok → Kimi** | — | ❌ Thin / empty |
| **Grok → Claude** | — | ❌ Thin / empty |

**This package fills the Grok-as-main row.**

If your daily driver is **Grok Build**, opening Claude just to run `/codex` is the wrong UX. You want peers **where you already are**.

<p align="center">
  <img src="assets/fig-peer-matrix.jpg" alt="Peer matrix: Claude main has official Codex; Grok main was empty" width="90%" />
</p>

<p align="center"><sub>Rows = conductor (main agent). Columns = peer. Official depth sits on Claude → Codex. Grok’s row was the gap.</sub></p>

---

## Peer table (what “solved” actually means)

| Main agent ↓ · Peer → | Codex | Claude | Grok | Kimi |
| --- | :---: | :---: | :---: | :---: |
| **Claude** | ✅ Official slash + app-server | — | △ MCP / community plugins | △ MCP (`kimi-code-mcp`) |
| **Grok Build** | **✅ This plugin** (`/codex-*`) | planned | — | **✅ This plugin** (`/kimi-analyze`) |
| **Codex** | — | △ | △ | △ |

| Symbol | Meaning |
| --- | --- |
| ✅ | Product-shaped slash / deep plugin |
| △ | CLI, MCP, or hand-rolled skill — works but not “feels like `/codex`” |
| — | Same agent / N/A |

Related transports (any MCP host, **not** Grok-native slash):

| Package | Role when *another* host is main |
| --- | --- |
| [`openai/codex-plugin-cc`](https://github.com/openai/codex-plugin-cc) | Claude → Codex peer UX |
| [`howardpen9/grok-mcp`](https://github.com/howardpen9/grok-mcp) | Host → Grok as reviewer / chat tools |
| [`howardpen9/kimi-code-mcp`](https://github.com/howardpen9/kimi-code-mcp) | Host → Kimi bulk reader (256K-style jobs) |
| **`grok-peer` (this repo)** | **Grok Build → Codex / Kimi call surface** |

---

## Two different multi-agent needs

People say “multi-agent” for **two different jobs**. Mixing them produces monorepos nobody uses.

| Mode | What you do | Best tool | This plugin? |
| --- | --- | --- | --- |
| **Side-by-side** | Long jobs, real parallel, compare two implementations | [Orca](https://onorca.dev/) / git worktrees | ❌ Not this |
| **In-window peer** | Short second opinion, review, bulk scan **without leaving the session** | Slash / plugin on the **current** host | ✅ **This** |

<p align="center">
  <img src="assets/fig-side-by-side-vs-peer.jpg" alt="Side-by-side vs in-window peer" width="90%" />
</p>

| | Side-by-side | In-window peer |
| --- | --- | --- |
| UX | Change **window / worktree** | Change **slash** |
| Latency | Session spin-up | Seconds–minutes of peer CLI |
| Isolation | Strong (separate checkout) | Same cwd; peer usually read-only for review |
| Example | Orca: Claude WP + Grok WP | Claude `/codex:review` · **Grok `/codex-review`** |

**Peer = transport + call surface.**  
Official Codex plugin ships both for Claude. This repo ships the **call surface when Grok is conductor**, using your local CLIs as transport.

---

## What you get

| Slash | Peer | Behavior |
| --- | --- | --- |
| `/peer-setup` | local CLIs | Report whether `codex` / `kimi` are installed and usable |
| `/codex-review` | **Codex** | Read-only review of uncommitted changes (or `--base <ref>`) |
| `/codex-adversarial` | **Codex** | Challenge design, races, security, simpler alternatives |
| `/kimi-analyze` | **Kimi** | One-shot bulk analysis of the current repo (default: tight summary) |

Uses **your** existing logins (`codex login`, `kimi login`). No second-subscription theater.

| Peer | Typical job | Why not Grok alone |
| --- | --- | --- |
| **Codex** | Diff / PR review, adversarial pass | Different model → breaks same-model confirmation bias |
| **Kimi** | Large / unfamiliar tree orientation | Cheaper long-context **reader**; keep Grok’s context for decisions |

---

## Install

### From GitHub (recommended)

```bash
grok plugin install howardpen9/grok-peer --trust
```

### Local path

```bash
git clone https://github.com/howardpen9/grok-peer.git
cd grok-peer
grok plugin validate .
grok plugin install . --trust
```

### Official marketplace

Catalog PR: [xai-org/plugin-marketplace#84](https://github.com/xai-org/plugin-marketplace/pull/84)  
After merge, install from Grok’s `/marketplace` (or `/plugin`) as **grok-peer**.

### First run

```text
/peer-setup
/codex-review
/codex-review --base main
/kimi-analyze summarize architecture and risks
```

---

## Prerequisites

| Tool | Required for | Setup |
| --- | --- | --- |
| [Grok Build](https://x.ai/cli) (`grok`) | host | `curl -fsSL https://x.ai/cli/install.sh \| bash` |
| [Codex CLI](https://github.com/openai/codex) | `/codex-*` | install + `codex login` |
| [Kimi Code CLI](https://www.kimi.com/code) | `/kimi-analyze` | install + `kimi login` |

Optional env overrides: `CODEX_BIN`, `KIMI_BIN`, `CLAUDE_BIN`.

---

## Decision tree

```text
Lots of files / real parallel / multi-repo?
  └─ yes → side-by-side stage (Orca / new worktree + dedicated agent)
  └─ no  → only second opinion or bulk scan?
        └─ yes → in-window peer (this plugin if main = Grok)
        └─ no  → finish in Grok + write your worklog
```

| Situation | Do this |
| --- | --- |
| Grok wrote a feature; want a second model on the diff | `/codex-review` or `/codex-adversarial` |
| Unfamiliar monorepo; don’t want Grok to read 50 files | `/kimi-analyze` then targeted edits |
| Two agents implementing in parallel | Orca / worktrees — **not** this plugin |
| Claude is your main | Use official `/codex` + optional MCP peers; this plugin is unnecessary |

---

## Security

See [SECURITY.md](./SECURITY.md).

| Claim | Detail |
| --- | --- |
| What runs | Local `scripts/*.sh` → `codex` / `kimi` on your PATH |
| Network | Only what those CLIs already do under **your** auth |
| Secrets | Plugin does not read `~/.ssh` or exfil env; may **detect** whether API key env vars are set |
| Hooks / MCP | None (least privilege) |

---

## Layout

```text
grok-peer/
  .grok-plugin/plugin.json
  LICENSE · README.md · SECURITY.md
  assets/                 # social + diagrams for docs
  commands/               # slash command prompts
  scripts/                # peer CLI runners
```

## Development

```bash
chmod +x scripts/*.sh
./scripts/peer-setup.sh
grok plugin validate .
```

## License

MIT — see [LICENSE](./LICENSE).

## Unofficial notice

Not affiliated with, endorsed by, or sponsored by xAI, OpenAI, or Moonshot. “Grok”, “Codex”, and “Kimi” are trademarks of their respective owners; names are used only for interoperability.
