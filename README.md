# Typst article skeleton

Minimal, reproducible Typst environment for technical writing with an AI coding agent.

## Arch Linux prerequisites

All primary tools are in the official Arch repositories:

```bash
sudo pacman -S typst tinymist typstyle just
```

Optional:

```bash
sudo pacman -S ttf-liberation   # Liberation Serif fallback (often already present)
sudo pacman -S direnv           # optional env loading for TYPST_FONT_PATHS
```

`just` is optional; you can call the underlying commands directly.

## First use

```bash
cp .envrc.example .envrc
$EDITOR .envrc
```

If using direnv:

```bash
direnv allow
```

Plain shell alternative (no direnv):

```bash
export TYPST_FONT_PATHS="$HOME/.local/share/article-fonts/microsoft"
```

Then:

```bash
just check
# or: ./scripts/check.sh
```

## Common workflow

```bash
just fmt
just check
just build
```

| Command | Effect |
|---------|--------|
| `just fmt` | Format Typst sources in place |
| `just check` | Full validation (`./scripts/check.sh`) |
| `just build` | Compile `main.typ` → `build/article.pdf` |
| `just watch` | Live recompile on change |
| `just clean` | Remove generated files under `build/` |

## AI workflow

Agents must treat `./scripts/check.sh` as the completion gate: format, validate, fix diagnostics, and repeat until it passes. See `AGENTS.md`.

## Proprietary fonts

- Font files stay **outside Git** (see `.gitignore`).
- Point `TYPST_FONT_PATHS` at a local directory you control.
- You are responsible for having an appropriate license for any proprietary fonts you use.
- Default body fonts: **Times New Roman**, then **Liberation Serif**.
- Strict local final builds:

  ```bash
  STRICT_FONTS=1 ./scripts/check.sh
  ```

  This fails if Times New Roman is unavailable and compiles with `--input strict-fonts=1` (no fallback family).

- CI deliberately does **not** require Microsoft fonts; it uses the fallback path.

### Editor preview fonts

Tinymist honors `TYPST_FONT_PATHS` when the editor process inherits that environment (for example, when launched from a direnv-enabled shell).

If the GUI does not see your shell env, set an explicit path in `.vscode/settings.json`:

```json
"tinymist.fontPaths": ["${env:HOME}/.local/share/article-fonts/microsoft"]
```

Do not commit machine-specific absolute home paths.

Recommended extension: `myriad-dreamin.tinymist` (official Tinymist).

## Layout

```text
main.typ              entrypoint
template/article.typ  shared style
src/                  prose sections
refs.bib              bibliography
figures/              assets
build/                generated PDF (ignored except .gitkeep)
scripts/check.sh      authoritative validation
```
