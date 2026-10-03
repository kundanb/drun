# drun

Scaffold projects with Docker. No Node.js install needed on your machine.

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop/), running
- `bash` and `curl` (macOS or Linux)

## Install

```bash
curl -fL https://raw.githubusercontent.com/kundanb/drun/main/install.sh | bash
```

This installs `drun` to `~/.local/bin`. If that directory isn't on your `PATH`, add it:

```bash
# zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Then restart your shell and check:

```bash
drun
```

## Usage

```bash
drun next <app-name>
```

Creates a Next.js app in `./<app-name>`, running `create-next-app` inside a `node:lts` container with these options:

- `src/` directory
- no git init
- rest of the options are default

## Update

Run the install command again.

## Uninstall

```bash
rm ~/.local/bin/drun
```
