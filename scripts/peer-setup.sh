#!/usr/bin/env bash
# Report readiness of peer CLIs for Grok Build.
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

ok=0
warn=0
fail=0

# required=1 → increments fail when missing; required=0 → warn only
check_bin() {
  local label="$1"
  local name="$2"
  local env_var="$3"
  local required="${4:-1}"
  local path
  if path="$(peer_resolve_bin "$name" "$env_var")"; then
    local ver
    ver="$("$path" --version 2>/dev/null | head -1 || echo "version unknown")"
    echo "  OK   $label  →  $path"
    echo "       $ver"
    ok=$((ok + 1))
  else
    if [[ "$required" == "1" ]]; then
      echo "  MISS $label  →  '$name' not on PATH"
      fail=$((fail + 1))
    else
      echo "  —    $label  →  '$name' not on PATH (optional)"
      warn=$((warn + 1))
    fi
    if [[ -n "$env_var" ]]; then
      echo "       (optional override: export $env_var=/path/to/$name)"
    fi
  fi
}

echo "grok-peer setup"
echo "cwd: $(pwd)"
echo ""
echo "Peer CLIs"
check_bin "Codex" "codex" "CODEX_BIN" 1
check_bin "Kimi" "kimi" "KIMI_BIN" 1
check_bin "Antigravity (agy)" "agy" "AGY_BIN" 0
check_bin "Claude (optional v0.1)" "claude" "CLAUDE_BIN" 0

echo ""
echo "Auth / env hints"
if peer_resolve_bin codex CODEX_BIN >/dev/null 2>&1; then
  if codex login status >/dev/null 2>&1 || codex whoami >/dev/null 2>&1; then
    echo "  OK   codex auth looks usable"
  else
    echo "  ?    could not confirm codex auth (try: codex login)"
    warn=$((warn + 1))
  fi
fi
if [[ -n "${KIMICODE_API_KEY:-}" || -n "${KIMI_API_KEY:-}" ]]; then
  echo "  OK   KIMICODE_API_KEY / KIMI_API_KEY is set (API path available)"
  ok=$((ok + 1))
else
  echo "  —    no KIMICODE_API_KEY in env (CLI login may still work for kimi)"
fi
if peer_resolve_bin agy AGY_BIN >/dev/null 2>&1; then
  if agy models >/dev/null 2>&1; then
    echo "  OK   agy models list works (signed in)"
  else
    echo "  ?    agy present but models list failed (try interactive: agy  → Google sign-in)"
    warn=$((warn + 1))
  fi
fi
if [[ -n "${XAI_API_KEY:-}" ]]; then
  echo "  OK   XAI_API_KEY is set (optional for other tools)"
else
  echo "  —    XAI_API_KEY unset (not required for this plugin)"
fi

echo ""
echo "Slash map (after plugin install)"
echo "  /peer-setup           this check"
echo "  /codex-review         Codex read-only review"
echo "  /codex-adversarial    Codex challenge review"
echo "  /kimi-analyze         Kimi bulk analyze (cwd)"
echo "  /gemini               Gemini LLM task spin via agy (default YOLO implement)"
echo "  /gemini --review      Gemini peer review (no skip-permissions)"
echo "  /gemini --image       Gemini image via agy generate_image (not Grok /imagine)"
echo "  /agy-run              alias → /gemini"
echo "  /agy-review           alias → /gemini --review"

echo ""
echo "Summary: ok=$ok  warn=$warn  miss=$fail"
if [[ "$fail" -gt 0 ]]; then
  echo "Install missing CLIs, then re-run /peer-setup."
  exit 1
fi
exit 0
