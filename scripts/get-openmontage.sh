#!/usr/bin/env bash
# Downloads OpenMontage (AGPL-3.0) next to this repo on demand. It is deliberately NOT committed here.
set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)/openmontage"
if [ ! -d "$DIR/.git" ]; then
  git clone --depth 1 https://github.com/calesthio/OpenMontage.git "$DIR"
fi
cd "$DIR"
if [ ! -d .venv ]; then
  python3 -m venv .venv
  . .venv/bin/activate
  python -m pip install -q -r requirements.txt
  python -m pip install -q piper-tts || echo "piper-tts install failed; narration will need another TTS provider"
  [ -f .env ] || cp .env.example .env
fi
if [ -d remotion-composer ] && [ ! -d remotion-composer/node_modules ]; then
  (cd remotion-composer && npm install --silent)
fi
echo "OpenMontage ready at $DIR"
