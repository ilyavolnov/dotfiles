#!/usr/bin/env bash
set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/thumbs"
mkdir -p "$CACHE_DIR"

make_thumb() {
  local id="$1"
  local out="$CACHE_DIR/${id}.png"
  [[ -f "$out" ]] && return 0

  local tmp
  tmp="$(mktemp)"
  if ! printf '%s\n' "$id" | cliphist decode >"$tmp" 2>/dev/null; then
    rm -f "$tmp"
    return 1
  fi

  local mime
  mime="$(file -b --mime-type "$tmp" 2>/dev/null || true)"
  if [[ "$mime" == image/* ]]; then
    convert "$tmp[0]" -thumbnail 96x96^ -gravity center -extent 96x96 "$out" 2>/dev/null || true
  fi
  rm -f "$tmp"
}

build_menu() {
  cliphist list | while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    local id desc short icon
    id="$(printf '%s' "$line" | awk '{print $1}')"
    desc="$(printf '%s' "$line" | sed -E 's/^[0-9]+[[:space:]]+//')"
    short="$(printf '%s' "$desc" | sed -E 's/[[:space:]]+/ /g' | cut -c1-110)"

    if [[ "$line" == *"[[ binary data"* ]]; then
      make_thumb "$id" || true
      icon="$CACHE_DIR/${id}.png"
      if [[ -f "$icon" ]]; then
        printf '%s\0icon\x1f%s\n' "$id  $short" "$icon"
      else
        printf '%s\n' "$id  $short"
      fi
    else
      printf '%s\n' "$id  $short"
    fi
  done
}

choice="$(build_menu | rofi -dmenu -i -p 'Clipboard' -theme "$HOME/.config/rofi/launchers/type-1/style-1.rasi")"
[[ -z "${choice:-}" ]] && exit 0

id="$(printf '%s' "$choice" | awk '{print $1}')"
[[ -z "$id" ]] && exit 0

printf '%s\n' "$id" | cliphist decode | wl-copy
