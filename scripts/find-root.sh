#!/usr/bin/env bash
# Print absolute path to grok-peer plugin root (directory containing scripts/).
set -euo pipefail
echo "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
