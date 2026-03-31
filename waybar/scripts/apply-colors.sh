#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wall-theme"
MATUGEN_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/matugen/hex"
mkdir -p "$STATE_DIR" "$MATUGEN_CACHE_DIR"

LOCK_FILE="$STATE_DIR/apply-colors.lock"
DESIRED_WALL="$STATE_DIR/desired_wallpaper"
APPLIED_WALL="$STATE_DIR/applied_wallpaper"
LAST_HEX="$STATE_DIR/last_hex"

ensure_hypr_instance() {
  if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    local sig
    sig=$(hyprctl instances 2>/dev/null | awk '/^instance /{print $2; exit}' | tr -d ':' || true)
    [[ -n "$sig" ]] && export HYPRLAND_INSTANCE_SIGNATURE="$sig"
  fi
}

compute_hex() {
  local img="$1"
  local hash cache_file
  hash=$(sha1sum "$img" | awk '{print $1}')
  cache_file="$MATUGEN_CACHE_DIR/$hash.hex"

  if [[ -f "$cache_file" ]]; then
    cat "$cache_file"
    return 0
  fi

  python - "$img" <<'PY' > "$cache_file"
from PIL import Image
import sys, colorsys, hashlib
path=sys.argv[1]
img=Image.open(path).convert('RGB').resize((128,128))
q=img.quantize(colors=8)
palette=q.getpalette()
colors=q.getcolors() or []

cands=[]
for count, idx in colors:
    r,g,b=palette[idx*3:idx*3+3]
    h,l,s=colorsys.rgb_to_hls(r/255.0,g/255.0,b/255.0)
    weight=(count/len(img.getdata()))**0.35
    cands.append((s*weight, s, count, r, g, b))

if not cands:
    r,g,b=127,127,127
else:
    cands.sort(reverse=True)
    top=cands[:3]
    h=int(hashlib.sha1(open(path,'rb').read(65536)).hexdigest(),16)
    _,_,_,r,g,b=top[h % len(top)]
print(f"#{r:02x}{g:02x}{b:02x}")
PY
  cat "$cache_file"
}

apply_for_image() {
  local img="$1"
  [[ -n "$img" && -f "$img" ]] || return 0

  ensure_hypr_instance

  if command -v matugen >/dev/null 2>&1; then
    local src_hex
    src_hex=$(compute_hex "$img")
    if matugen --config "$HOME/.config/matugen/config.toml" color hex "$src_hex" --mode dark --type scheme-tonal-spot --quiet >/dev/null 2>&1; then
      printf '%s\n' "$src_hex" > "$LAST_HEX"
    else
      echo "[apply-colors] matugen generation failed for $img" >> "$HOME/.cache/matugen/apply-colors.log"
    fi
  fi

  # Update Hyprland colors (avoid hard-failing the whole pipeline)
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
  fi

  # Update Waybar CSS (no forced reload to avoid visible flicker)
  if [[ -f "$HOME/.cache/matugen/colors-waybar.css" ]]; then
    WAYBAR_CSS_DIR="$HOME/.config/waybar/styles"
    mkdir -p "$WAYBAR_CSS_DIR"
    cp "$HOME/.cache/matugen/colors-waybar.css" "$WAYBAR_CSS_DIR/colors-waybar.css"
  fi

  # Update Kitty colors
  if [[ -f "$HOME/.cache/matugen/colors-kitty.conf" ]]; then
    kitty @ set-colors -a -c "$HOME/.cache/matugen/colors-kitty.conf" >/dev/null 2>&1 || true
  fi

  # Update Quickshell: hard restart so theme is always reloaded
  if command -v qs >/dev/null 2>&1; then
    qs kill -c ii >/dev/null 2>&1 || true
    pkill -x qs >/dev/null 2>&1 || true
    pkill -x quickshell >/dev/null 2>&1 || true
    # give layers a moment to tear down cleanly
    sleep 0.25
    nohup qs -c ii >/dev/null 2>&1 &
  elif command -v quickshell >/dev/null 2>&1; then
    quickshell kill -c ii >/dev/null 2>&1 || true
    pkill -x quickshell >/dev/null 2>&1 || true
    sleep 0.25
    nohup quickshell -c ii >/dev/null 2>&1 &
  fi

  # Update Rofi (if running)
  if pgrep -x rofi >/dev/null 2>&1; then
    # Rofi will reload automatically when colors-rofi.rasi changes
    # We need to update the file
    if [[ -f "$HOME/.cache/matugen/colors-rofi.rasi" ]]; then
      cp "$HOME/.cache/matugen/colors-rofi.rasi" "$HOME/.cache/matugen/colors-rofi.rasi"
    fi
  fi
}

run_worker() {
  exec 9>"$LOCK_FILE"
  flock -n 9 || exit 0

  while true; do
    [[ -f "$DESIRED_WALL" ]] || exit 0
    local desired applied
    desired=$(cat "$DESIRED_WALL" 2>/dev/null || true)
    applied=$(cat "$APPLIED_WALL" 2>/dev/null || true)

    [[ -n "$desired" ]] || exit 0
    if [[ "$desired" != "$applied" ]]; then
      if apply_for_image "$desired"; then
        printf '%s\n' "$desired" > "$APPLIED_WALL"
        printf '[%s] applied: %s\n' "$(date '+%F %T')" "$desired" >> "$STATE_DIR/apply-colors.log"
      else
        printf '[%s] failed: %s\n' "$(date '+%F %T')" "$desired" >> "$STATE_DIR/apply-colors.log"
      fi
      # tiny debounce window for rapid wallpaper switching
      sleep 0.15
      continue
    fi
    break
  done
}

if [[ "${1:-}" == "--worker" ]]; then
  run_worker
  exit 0
fi

img="${1:-}"
[[ -n "$img" && -f "$img" ]] || {
  echo "Usage: $0 /path/to/image | --worker" >&2
  exit 1
}
if apply_for_image "$img"; then
  printf '%s\n' "$img" > "$APPLIED_WALL"
  printf '[%s] applied: %s\n' "$(date '+%F %T')" "$img" >> "$STATE_DIR/apply-colors.log"
else
  printf '[%s] failed: %s\n' "$(date '+%F %T')" "$img" >> "$STATE_DIR/apply-colors.log"
  exit 1
fi