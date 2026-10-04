#!/usr/bin/env bash

set -euo pipefail

BASE="https://raw.githubusercontent.com/kundanb/drun/main"
DEST_DIR="$HOME/.local/bin"
RC="$HOME/.zshrc"
LINE='export PATH="$HOME/.local/bin:$PATH"'

mkdir -p "$DEST_DIR"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fL "$BASE/drun.sh" -o "$tmp"
install -m 755 "$tmp" "$DEST_DIR/drun"
echo "Installed to $DEST_DIR/drun"

case ":$PATH:" in
    *":$DEST_DIR:"*) ;;
    *)
        grep -qxF "$LINE" "$RC" 2>/dev/null || echo "$LINE" >> "$RC"
        echo "Added $DEST_DIR to PATH in $RC. Restart your terminal."
        ;;
esac
