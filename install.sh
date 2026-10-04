#!/usr/bin/env bash

# Installer for drun. Downloads the repo once and installs:
#   - the drun.sh script as `drun` in ~/.local/bin
#   - the project templates in ~/.local/share/drun/templates
#
# Exit on error (-e), on unset variables (-u), and on failures
# anywhere in a pipeline (pipefail), e.g. a failed curl before tar.
set -euo pipefail

# Tarball of the repo's main branch (top-level folder inside is `drun-main/`).
TARBALL="https://codeload.github.com/kundanb/drun/tar.gz/main"

# Where the executable goes.
BIN_DIR="$HOME/.local/bin"

# Where read-only data (templates) goes, following the XDG convention.
DATA_DIR="$HOME/.local/share/drun"

# Shell config to update if BIN_DIR is not already on PATH.
RC="$HOME/.zshrc"

# Single quotes keep $HOME and $PATH literal, so they expand
# when the shell starts, not when this script runs.
LINE='export PATH="$HOME/.local/bin:$PATH"'

# Extract into a temp dir first so a failed download never leaves a
# half-installed state. The trap removes it on success, error, or Ctrl-C.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Download and unpack. --strip-components=1 drops the `drun-main/` prefix,
# so files land directly in $tmp (e.g. $tmp/drun.sh, $tmp/templates/).
curl -fL "$TARBALL" | tar -xz -C "$tmp" --strip-components=1

# Only reached if the download succeeded (set -e aborts otherwise).
mkdir -p "$BIN_DIR" "$DATA_DIR"

# Install the script as `drun` (no .sh) with executable permissions.
install -m 755 "$tmp/drun.sh" "$BIN_DIR/drun"

# Remove old templates before copying, so files deleted upstream
# don't linger after an update.
rm -rf "$DATA_DIR/templates"
cp -R "$tmp/templates" "$DATA_DIR/templates"
echo "Installed to $BIN_DIR/drun"

# Add BIN_DIR to PATH only if it's missing. Wrapping both sides in colons
# makes the match exact, so ".../bin" doesn't match ".../bin2".
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;  # already on PATH, nothing to do
    *)
        # Append the export line only if it's not already in the rc file
        # (-q quiet, -x whole line, -F fixed string). Errors are hidden
        # in case the file doesn't exist yet.
        grep -qxF "$LINE" "$RC" 2>/dev/null || echo "$LINE" >> "$RC"
        echo "Added $BIN_DIR to PATH in $RC. Restart your terminal."
        ;;
esac
