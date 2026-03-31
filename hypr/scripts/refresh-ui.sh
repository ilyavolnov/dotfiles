#!/usr/bin/env bash
set -euo pipefail

# Theme refresh on wallpaper change:
# - reload Waybar CSS/colors (without full restart)
# - restart QuickShell so new palette is guaranteed to apply

pkill -SIGUSR2 waybar >/dev/null 2>&1 || true

if command -v qs >/dev/null 2>&1; then
  pkill -x quickshell >/dev/null 2>&1 || true
  nohup qs -c ii >/tmp/quickshell.log 2>&1 &
fi
