#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="${WALLPAPER_DIR:-$HOME/wallpapers}"
THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/rofi-wallpaper-thumbs"
THEME="$HOME/.config/rofi/launchers/type-2/style-4.rasi"
mkdir -p "$THUMB_DIR"

[[ -d "$WALL_DIR" ]] || {
  notify-send "Wallpaper picker" "Folder not found: $WALL_DIR"
  exit 1
}

mapfile -t files < <(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)
[[ ${#files[@]} -gt 0 ]] || {
  notify-send "Wallpaper picker" "No images in $WALL_DIR"
  exit 1
}

build_menu() {
  local i=0 f key thumb label
  for f in "${files[@]}"; do
    key=$(printf '%s' "$f" | sha1sum | awk '{print $1}')
    thumb="$THUMB_DIR/${key}.png"
    label=$(basename "$f")

    # Trim long names for cleaner cards
    if (( ${#label} > 26 )); then
      label="${label:0:23}..."
    fi

    if [[ ! -f "$thumb" || "$f" -nt "$thumb" ]]; then
      if command -v magick >/dev/null 2>&1; then
        magick "$f" -auto-orient -resize 720x405^ -gravity center -extent 720x405 "$thumb" 2>/dev/null || cp -f "$f" "$thumb"
      elif command -v convert >/dev/null 2>&1; then
        convert "$f" -auto-orient -resize 720x405^ -gravity center -extent 720x405 "$thumb" 2>/dev/null || cp -f "$f" "$thumb"
      else
        cp -f "$f" "$thumb"
      fi
    fi

    printf '%s\0icon\x1f%s\n' "$label" "$thumb"
    i=$((i + 1))
  done
}

idx=$(build_menu | rofi -dmenu -i -show-icons -format 'i' -theme "$THEME" -theme-str 'inputbar { enabled: false; } message { enabled: false; } listview { columns: 3; lines: 3; spacing: 8px; scrollbar: false; } element { orientation: vertical; padding: 6px; margin: 0px; background-color: transparent; border-radius: 8px; } element selected.normal { background-color: transparent; border: 2px; border-color: @selected; } element-icon { size: 180px; border-radius: 8px; } element-text { enabled: true; horizontal-align: 0.5; vertical-align: 0.5; } window { width: 46%; border-radius: 12px; } mainbox { padding: 8px; spacing: 6px; }')

[[ -n "${idx:-}" ]] || exit 0
[[ "$idx" =~ ^[0-9]+$ ]] || exit 1

selected="${files[$idx]}"
[[ -f "$selected" ]] || exit 1

"$HOME/.config/waybar/scripts/set-wallpaper.sh" "$selected"