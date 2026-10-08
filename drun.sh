#!/usr/bin/env bash

set -euo pipefail

TEMPLATES="$HOME/.local/share/drun/templates"
INSTALL_URL="https://raw.githubusercontent.com/kundanb/drun/main/install.sh"

usage() {
    echo "Usage: $(basename "$0") next <app-name>" >&2
    echo "       $(basename "$0") vite <app-name> <template>" >&2
    echo "       $(basename "$0") vitepress|vp <app-name>" >&2
    echo "       $(basename "$0") update" >&2
    exit 1
}

run() {
    docker run --rm -it -v "$PWD:/app" -w /app "$@"
}

template() {
    cp -R "$TEMPLATES/$1/." ./
}

update() {
    curl -fsSL "$INSTALL_URL" | bash
}

case "${1:-}" in
    next)
        [[ -n "${2:-}" ]] || usage
        mkdir -p "$2" && cd "$2"
        run node:lts npx create-next-app@latest .
        template next
        ;;
    vite)
        [[ -n "${2:-}" && -n "${3:-}" ]] || usage
        mkdir -p "$2" && cd "$2"
        run node:lts npm create vite@latest . -- --template "$3"
        template vite
        ;;
    vitepress|vp)
        [[ -n "${2:-}" ]] || usage
        mkdir -p "$2" && cd "$2"
        run node:lts sh -c '
            npm init -y &&
            npm add -D vitepress@next &&
            npx vitepress init
        '
        template vitepress
        ;;
    update)
        update
        ;;
    *)
        usage
        ;;
esac
