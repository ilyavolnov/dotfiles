#!/usr/bin/env bash
set -euo pipefail

# Prevent multiple launcher instances
if pgrep -x rofi >/dev/null 2>&1; then
  exit 0
fi

exec rofi -show drun -theme "$HOME/.config/rofi/launchers/type-1/style-1.rasi"
