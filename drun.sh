#!/usr/bin/env bash

# drun: scaffold a Next.js or Vite app inside a Docker container
# (so no local Node install is needed), then overlay a local template.
#
# Exit on error (-e), on unset variables (-u), and on pipeline failures.
set -euo pipefail

# Templates copied here by install.sh. No network needed at run time.
TEMPLATES="$HOME/.local/share/drun/templates"

# URL of the installer script for self-updating.
INSTALL_URL="https://raw.githubusercontent.com/kundanb/drun/main/install.sh"

# Print usage to stderr and exit with a failure code.
usage() {
    echo "Usage: $(basename "$0") next <app-name>" >&2
    echo "       $(basename "$0") vite <app-name> <template>" >&2
    echo "       $(basename "$0") update" >&2
    exit 1
}

# Run a command in a throwaway Node container.
#   --rm        delete the container when it exits
#   -it         interactive with a TTY (the scaffolders prompt for input)
#   -v          mount the current directory at /app, so the generated app
#               appears on the host
#   -w /app     start in the mounted directory
# "$@" is the image plus the command to run, e.g. node:lts npx ...
run() {
    docker run --rm -it -v "$PWD:/app" -w /app "$@"
}

# Overlay a template onto the generated app.
#   $1 = app directory, $2 = template name
# The trailing "/." copies directory contents including dotfiles.
# Existing files (package.json, .gitignore, ...) are overwritten.
template() {
    cp -R "$TEMPLATES/$2/." "$1/"
}

# Update drun and its templates by running the official installer.
update() {
    curl -fsSL "$INSTALL_URL" | bash
}

# Dispatch on the first argument (empty string if none, to satisfy -u).
case "${1:-}" in
    next)
        # Require an app name.
        [[ -n "${2:-}" ]] || usage
        # Scaffold with the latest create-next-app, then apply our template.
        run node:lts npx create-next-app@latest "$2"
        template "$2" next
        ;;
    vite)
        # Require both an app name and a Vite template (react-ts, vue, ...).
        [[ -n "${2:-}" && -n "${3:-}" ]] || usage
        # `--` passes --template through npm to create-vite.
        run node:lts npm create vite@latest "$2" -- --template "$3"
        template "$2" vite
        ;;
    update|update-templates)
        update
        ;;
    *)
        # Unknown or missing subcommand.
        usage
        ;;
esac
