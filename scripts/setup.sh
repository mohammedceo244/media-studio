#!/usr/bin/env bash
# Prepares a cloud session for video work. Fast and idempotent: skips anything already present.
set -u
log() { echo "[media-studio] $*"; }

if ! command -v ffmpeg >/dev/null 2>&1; then
  log "installing ffmpeg"
  (sudo -n apt-get update -qq && sudo -n apt-get install -y -qq ffmpeg) >/dev/null 2>&1 \
    || (apt-get update -qq && apt-get install -y -qq ffmpeg) >/dev/null 2>&1 \
    || log "could not install ffmpeg automatically; ask Claude to install it"
fi

# Make the Vazirmatn brand font available to headless Chrome renders.
FONT_DIR="$HOME/.local/share/fonts/vazirmatn"
if [ ! -f "$FONT_DIR/Vazirmatn-Regular.ttf" ]; then
  mkdir -p "$FONT_DIR" && cp "$CLAUDE_PROJECT_DIR"/brand/fonts/*.ttf "$FONT_DIR"/ 2>/dev/null
  command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$FONT_DIR" >/dev/null 2>&1
fi

mkdir -p "$CLAUDE_PROJECT_DIR/output"
log "ready (node $(node -v 2>/dev/null), $(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f1-3))"
exit 0
