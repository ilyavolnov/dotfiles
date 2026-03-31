#!/usr/bin/env bash
set -euo pipefail

choice="$(cliphist list | rofi -dmenu -i -p 'Clipboard')"
[[ -z "${choice:-}" ]] && exit 0

id="$(printf '%s' "$choice" | awk '{print $1}')"
[[ -z "$id" ]] && exit 0

printf '%s\n' "$id" | cliphist decode | wl-copy
