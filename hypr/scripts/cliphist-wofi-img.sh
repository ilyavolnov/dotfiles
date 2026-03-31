#!/usr/bin/env bash
set -euo pipefail

THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-wofi-thumbs"
mkdir -p "$THUMB_DIR"
MAX_CHARS=95

trim_line() {
  local s="$1"
  # collapse whitespace
  s="$(printf '%s' "$s" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g')"
  if [ "${#s}" -gt "$MAX_CHARS" ]; then
    printf '%s…' "${s:0:$((MAX_CHARS-1))}"
  else
    printf '%s' "$s"
  fi
}

build_menu() {
  cliphist list | while IFS= read -r line; do
    [ -z "$line" ] && continue

    id="$(printf '%s' "$line" | awk '{print $1}')"
    desc="$(printf '%s' "$line" | sed -E 's/^[0-9]+[[:space:]]+//')"
    short="$(trim_line "$desc")"

    if [[ "$desc" == *"[[ binary data"* ]]; then
      key="$(printf '%s' "$id" | sha1sum | awk '{print $1}')"
      thumb="$THUMB_DIR/${key}.png"

      if [ ! -f "$thumb" ]; then
        tmp="$(mktemp)"
        if printf '%s\n' "$id" | cliphist decode >"$tmp" 2>/dev/null; then
          mime="$(file -b --mime-type "$tmp" 2>/dev/null || true)"
          if [[ "$mime" == image/* ]]; then
            if command -v magick >/dev/null 2>&1; then
              magick "$tmp[0]" -auto-orient -resize 96x96^ -gravity center -extent 96x96 "$thumb" 2>/dev/null || true
            else
              convert "$tmp[0]" -auto-orient -resize 96x96^ -gravity center -extent 96x96 "$thumb" 2>/dev/null || true
            fi
          fi
        fi
        rm -f "$tmp"
      fi

      if [ -f "$thumb" ]; then
        printf 'img:%s:text:%s  %s\n' "$thumb" "$id" "$short"
      else
        printf '%s  %s\n' "$id" "$short"
      fi
    else
      printf '%s  %s\n' "$id" "$short"
    fi
  done
}

choice="$(build_menu | wofi --dmenu --allow-images --prompt 'Clipboard ::' -c "$HOME/.config/wofi/config" -s "$HOME/.config/wofi/style.css")"
[ -z "${choice:-}" ] && exit 0

id="$(printf '%s' "$choice" | awk '{print $1}')"
[ -z "$id" ] && exit 0

printf '%s\n' "$id" | cliphist decode | wl-copy
