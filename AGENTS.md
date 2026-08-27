# Agent contract — Typst article skeleton

This repository is for writing academic/technical articles in Typst with an AI coding agent. Follow this contract exactly.

## Scope

| Path | Role |
|------|------|
| `main.typ` | Document entrypoint only |
| `src/` | Article prose / content |
| `template/` | Shared layout and styling |
| `refs.bib` | Bibliography |
| `figures/` | Source figures (committed assets) |
| `build/` | Generated outputs only |

Rules:

- Never edit generated PDFs under `build/` or any `*.pdf` artifact.
- Keep presentation logic in `template/`; keep prose in `src/`.
- Do not commit font binaries (`.ttf`, `.otf`, `.ttc`, …).

## Editing loop

After changing Typst sources:

1. Format changed files (`just fmt` or `typstyle -i …`).
2. Run `./scripts/check.sh`.
3. Inspect diagnostics.
4. Fix failures.
5. Repeat until validation succeeds.

**Never claim completion while `./scripts/check.sh` fails.**

## Writing safety

Do **not** invent:

- citations
- DOI values
- bibliography entries
- experimental results
- measurements
- statistics
- quotes
- factual findings

If evidence is missing, mark it explicitly (for example `[TODO: citation needed]`) rather than fabricating it.

The entry in `refs.bib` marked as example data is a fixture for toolchain testing only. Replace it before treating the article as real scholarship.

## Typst conventions

- Prefer semantic Typst constructs (`heading`, `figure`, `table`, `cite`, …).
- Avoid hard-coded spacing hacks.
- Preserve labels and references unless intentionally restructuring.
- Keep presentation logic out of content files where practical.
- Avoid giant monolithic `.typ` files; compose via `#include`.

## Fonts

- Local proprietary fonts (for example Times New Roman) may be used via `TYPST_FONT_PATHS`.
- Default body font fallback: Times New Roman → Liberation Serif.
- Strict final builds: `STRICT_FONTS=1 ./scripts/check.sh` (fails if Times New Roman is unavailable; compiles with `--input strict-fonts=1`).
- CI must not depend on Microsoft fonts.

## Validation

`./scripts/check.sh` is the **authoritative completion gate**.

Convenience wrappers:

- `just check` → `./scripts/check.sh`
- `just fmt` → format sources
- `just build` → compile PDF
- `just watch` → live compile
- `just clean` → remove build artifacts (keeps `build/.gitkeep`)
