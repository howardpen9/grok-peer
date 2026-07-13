#!/usr/bin/env bash
# Shared helpers for grok-peer scripts.
set -euo pipefail

peer_die() {
  echo "grok-peer: $*" >&2
  exit 1
}

peer_have() {
  command -v "$1" >/dev/null 2>&1
}

peer_plugin_root() {
  # scripts/ -> plugin root
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

peer_resolve_bin() {
  # usage: peer_resolve_bin NAME ENV_VAR
  local name="$1"
  local env_var="${2:-}"
  if [[ -n "${env_var}" && -n "${!env_var:-}" && -x "${!env_var}" ]]; then
    echo "${!env_var}"
    return 0
  fi
  if peer_have "$name"; then
    command -v "$name"
    return 0
  fi
  return 1
}
