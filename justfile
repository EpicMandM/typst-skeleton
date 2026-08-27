# Typst article skeleton — local task runner

set shell := ["bash", "-euo", "pipefail", "-c"]

entry := "main.typ"
pdf := "build/article.pdf"
typ_sources := "main.typ template src"

# Compile main.typ → build/article.pdf
build:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p build
    args=()
    if typst fonts | grep -Fxq "Times New Roman"; then
      :
    elif typst fonts | grep -Fxq "Liberation Serif"; then
      args+=(--input "body-font=Liberation Serif")
    fi
    typst compile "${args[@]}" "{{entry}}" "{{pdf}}"
    test -s "{{pdf}}"
    echo "wrote {{pdf}}"

# Run authoritative validation (does not modify sources)
check:
    ./scripts/check.sh

# Format Typst sources in place
fmt:
    typstyle -i {{typ_sources}}

# Live recompile on change
watch:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p build
    args=()
    if typst fonts | grep -Fxq "Times New Roman"; then
      :
    elif typst fonts | grep -Fxq "Liberation Serif"; then
      args+=(--input "body-font=Liberation Serif")
    fi
    typst watch "${args[@]}" "{{entry}}" "{{pdf}}"

# Remove generated build artifacts only
clean:
    find build -mindepth 1 ! -name '.gitkeep' -delete
    @echo "cleaned build/"
