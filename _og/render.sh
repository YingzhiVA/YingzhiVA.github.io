#!/usr/bin/env bash
#
# Rebuild the Open Graph preview cards from the generators in this directory.
# Each generator renders to a 1200x630 PNG that sits next to its article.
#
# Chromium here is a snap, so it has a private /tmp and cannot read anything
# outside $HOME. The source HTML is staged next to its output before rendering
# and removed afterwards; rendering straight from a temp directory silently
# produces an ERR_FILE_NOT_FOUND screenshot instead of failing.
#
# Usage: _og/render.sh

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

render() {
  local src="$1" out="$2"
  local dir
  dir="$(dirname "$out")"

  cp "$src" "$dir/.og-build.html"
  chromium --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor=1 \
    --user-data-dir="$dir/.cr-profile" \
    --window-size=1200,630 \
    --screenshot="$out" \
    "file://$dir/.og-build.html" 2>/dev/null
  rm -rf "$dir/.og-build.html" "$dir/.cr-profile"

  echo "wrote ${out#"$root"/}"
}

render "$root/_og/leakage-card.html" \
       "$root/notes/referral-analytics/encoder-first/leakage-card.png"

render "$root/_og/fold-spread-card.html" \
       "$root/notes/referral-analytics/stop-tuning/fold-spread-card.png"
