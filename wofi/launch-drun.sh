#!/usr/bin/env bash
set -euo pipefail

# Prevent multiple launcher instances
if pgrep -x wofi >/dev/null 2>&1; then
  exit 0
fi

exec wofi --show drun
