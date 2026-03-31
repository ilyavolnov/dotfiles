#!/usr/bin/env bash
# Color picker script for Hyprland + Waybar
# Uses hyprpicker for native color picking with eyedropper

set -euo pipefail

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/colorpicker-last"

# Check if we need JSON output for waybar
if [[ "${1:-}" == "-j" ]]; then
    if [[ -f "$CACHE_FILE" ]]; then
        COLOR=$(cat "$CACHE_FILE")
        echo "{\"text\": \"\", \"tooltip\": \"Last: $COLOR\"}"
    else
        echo "{\"text\": \"\", \"tooltip\": \"Click to pick color\"}"
    fi
    exit 0
fi

# Check for hyprpicker
if ! command -v hyprpicker &>/dev/null; then
    notify-send "Color Picker" "Error: hyprpicker required" -u critical
    exit 1
fi

# Pick color using hyprpicker with autocopy (-a) and render-inactive (-r)
COLOR=$(hyprpicker -a -r -l)

if [[ -z "$COLOR" ]]; then
    # User cancelled
    exit 0
fi

# Save to cache
mkdir -p "$(dirname "$CACHE_FILE")"
echo "$COLOR" > "$CACHE_FILE"

# Notify user
notify-send "Color Picker" "Color copied: $COLOR" -t 2000
