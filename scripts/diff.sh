#!/usr/bin/env bash
# Build build/diff.pdf: the current paper with changes since <base-ref>
# marked inline (removed text in red, added text in blue).
#
# Usage: scripts/diff.sh [base-ref]   (default: origin/main)
set -euo pipefail

BASE="${1:-origin/main}"
ROOT="$(git rev-parse --show-toplevel)"
PAPER_DIR="paper"
MAIN="main.tex"

cd "$ROOT"

if ! git rev-parse --verify --quiet "$BASE^{commit}" >/dev/null; then
  echo "error: base ref '$BASE' not found (try 'git fetch' or pass another ref)" >&2
  exit 1
fi

OLD="$(mktemp -d)"
trap 'rm -rf "$OLD" "$ROOT/$PAPER_DIR/diff.tex"' EXIT

# Export the paper as it was at BASE.
git archive "$BASE" "$PAPER_DIR" | tar -x -C "$OLD"

# --flatten inlines \input/\include so changes inside sections are tracked.
# (The warning about a missing main.bbl is harmless: the bibliography is
# compiled normally from references.bib.)
latexdiff --flatten --type=UNDERLINE \
  "$OLD/$PAPER_DIR/$MAIN" "$PAPER_DIR/$MAIN" > "$PAPER_DIR/diff.tex"

# Compile next to main.tex so figures and the bibliography resolve.
cd "$PAPER_DIR"
latexmk -outdir=../build diff.tex

echo "diff written to build/diff.pdf (base: $BASE)"
