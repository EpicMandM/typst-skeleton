#!/usr/bin/env bash
# Authoritative project validation. Does not modify sources.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

STRICT_FONTS="${STRICT_FONTS:-0}"
REQUIRED_FONT="Times New Roman"
FALLBACK_FONT="Liberation Serif"
ENTRY="main.typ"
OUT="build/article.pdf"
TYP_SOURCES=(main.typ template src)

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

ok() {
  printf 'ok: %s\n' "$*"
}

need_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "required tool not found: $cmd"
}

echo "==> checking required tools"
need_cmd typst
need_cmd typstyle
need_cmd tinymist
ok "typst $(typst --version | head -n1)"
ok "typstyle available"
ok "tinymist available"

echo "==> font discovery"
mapfile -t AVAILABLE_FONTS < <(typst fonts | sed '/^$/d')
has_font() {
  local needle="$1"
  local family
  for family in "${AVAILABLE_FONTS[@]}"; do
    if [[ "$family" == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

SELECTED_FONT=""
EXTRA_ARGS=()

if [[ "$STRICT_FONTS" == "1" ]]; then
  echo "==> strict font validation (STRICT_FONTS=1)"
  if has_font "$REQUIRED_FONT"; then
    ok "strict font present: $REQUIRED_FONT"
    EXTRA_ARGS+=(--input "strict-fonts=1")
  else
    fail "STRICT_FONTS=1 requires '$REQUIRED_FONT' (set TYPST_FONT_PATHS to a licensed local font directory)"
  fi
else
  if has_font "$REQUIRED_FONT"; then
    SELECTED_FONT="$REQUIRED_FONT"
    ok "using font: $SELECTED_FONT"
  elif has_font "$FALLBACK_FONT"; then
    SELECTED_FONT="$FALLBACK_FONT"
    ok "Times New Roman unavailable; using fallback: $SELECTED_FONT"
  else
    fail "neither '$REQUIRED_FONT' nor '$FALLBACK_FONT' is available via \`typst fonts\`"
  fi
  # Pin a concrete available face so tinymist does not fail on missing preferred fonts.
  EXTRA_ARGS+=(--input "body-font=${SELECTED_FONT}")
  ok "strict font mode disabled (set STRICT_FONTS=1 to require Times New Roman)"
fi

echo "==> formatting check (typstyle --check)"
typstyle --check "${TYP_SOURCES[@]}"
ok "formatting clean"

echo "==> tinymist lint"
tinymist lint "${EXTRA_ARGS[@]}" "$ENTRY"
ok "tinymist lint passed"

echo "==> compile"
mkdir -p build
typst compile "${EXTRA_ARGS[@]}" "$ENTRY" "$OUT"
[[ -s "$OUT" ]] || fail "expected non-empty PDF at $OUT"
ok "compiled $OUT ($(wc -c <"$OUT") bytes)"

echo
echo "ALL CHECKS PASSED"
