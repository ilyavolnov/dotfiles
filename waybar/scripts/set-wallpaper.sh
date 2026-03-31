#!/usr/bin/env bash
set -euo pipefail

img="${1:-}"
[[ -n "$img" && -f "$img" ]] || {
  echo "Usage: $0 /path/to/image" >&2
  exit 1
}

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wall-theme"
mkdir -p "$STATE_DIR"
LAST_WALL="$STATE_DIR/current_wallpaper"
DESIRED_WALL="$STATE_DIR/desired_wallpaper"

# Skip full pipeline if same wallpaper selected again
if [[ -f "$LAST_WALL" ]] && [[ "$(cat "$LAST_WALL")" == "$img" ]]; then
  exit 0
fi

# Set wallpaper
if command -v awww >/dev/null 2>&1; then
  awww img "$img" --transition-type grow --transition-fps 60 --transition-duration 1
else
  echo "awww not found, skipping wallpaper" >&2
fi

printf '%s\n' "$img" > "$LAST_WALL"
printf '%s\n' "$img" > "$DESIRED_WALL"

# Apply colors for the selected wallpaper immediately (background)
nohup "$HOME/.config/waybar/scripts/apply-colors.sh" "$img" >/dev/null 2>&1 &