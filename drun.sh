#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 next <app-name>" >&2
    exit 1
}

run() {
    exec docker run --rm \
        -u "$(id -u):$(id -g)" \
        -e HOME=/tmp \
        -v "$PWD:/app" -w /app \
        "$@"
}

case "${1:-}" in
    next)
        [[ -n "${2:-}" ]] || usage
        run node:lts npx -y create-next-app@latest "$2" --src-dir --disable-git
        ;;
    *)
        usage
        ;;
esac
