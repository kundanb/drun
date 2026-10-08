# drun

Scaffold projects with Docker on macOS. No Node.js install needed on your machine.

## Requirements

- macOS
- [Docker Desktop](https://www.docker.com/products/docker-desktop/), running

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/kundanb/drun/main/install.sh | bash
```

This installs:

- `drun` to `~/.local/bin`
- project templates to `~/.local/share/drun/templates`

If `~/.local/bin` isn't on your `PATH`, the installer adds it to `~/.zshrc` for you.

Then reload your shell and check:

```bash
source ~/.zshrc
drun
```

## Usage

### Next.js

```bash
drun next <app-name>
```

Runs `create-next-app@latest` inside a `node:lts` container (it prompts for options as usual), then overlays the `next` template on top of the generated app.

### Vite

```bash
drun vite <app-name> <template>
```

Runs `create-vite@latest` inside a `node:lts` container with the given Vite template (e.g. `react-ts`, `vue`), then overlays the `vite` template on top of the generated app.

### VitePress

```bash
drun vitepress <app-name>
# or: drun vp <app-name>
```

Runs `vitepress init` inside a `node:lts` container (it prompts for options as usual), then overlays the `vitepress` template on top of the generated app.

### Starlight

```bash
drun starlight <app-name>
```

Runs `npm create astro@latest -- --template starlight` inside a `node:lts` container (it prompts for options as usual), then overlays the `starlight` template on top of the generated app.

### Templates

Templates are copied from `~/.local/share/drun/templates` and overwrite files with the same name in the generated app (e.g. `package.json`, `.gitignore`). No network is needed for this step.

## Update

```bash
drun update
```

Updates `drun` and refreshes the templates. Files removed upstream are removed locally.

Alternatively, run the install command again.

## Uninstall

```bash
rm ~/.local/bin/drun
rm -rf ~/.local/share/drun
```

Optionally, remove this line from `~/.zshrc` if the installer added it:

```bash
export PATH="$HOME/.local/bin:$PATH"
```
