#!/usr/bin/env bash

set -euo pipefail

BASE="https://raw.githubusercontent.com/kundanb/drun/main"
DEST_DIR="$HOME/.local/bin"

mkdir -p "$DEST_DIR"
curl -fL "$BASE/drun.sh" -o "$DEST_DIR/drun"
chmod +x "$DEST_DIR/drun"

echo "Installed to $DEST_DIR/drun"
echo "Add $DEST_DIR to your PATH if it's not already there."
