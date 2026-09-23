# Instructions for AI assistants

This repository contains a LaTeX paper. Authors review every change you make as a line diff and as a PDF diff, so keep changes small and easy to review.

## Editing rules

- **One sentence per line.** Keep this format in everything you write. Never join sentences on one line and never wrap a sentence over several lines.
- **Change only what was asked.** Do not rewrite, reorder or "improve" other sentences, paragraphs or sections.
- **Do not reformat.** Keep existing indentation, blank lines, comments and line order. Never re-wrap paragraphs.
- **Do not touch LaTeX structure** unless asked: `\label`, `\ref`, `\cite` keys, `\input`, equations, environments, figures, tables and the preamble in `paper/main.tex`.
- **Keep `% !TEX root = ../main.tex`** as the first line of every file in `paper/sections/`.
- **Language:** American English, formal academic register. Keep the authors' terminology consistent throughout the paper.
- **Citations:** never invent references or citation keys. Only cite entries that exist in `paper/references.bib`; if a claim needs a new source, say so instead of adding one.
- **Numbers and results:** never change values in text, tables or figures unless explicitly asked.

## Project layout

- `paper/main.tex`: preamble and `\input` of each section.
- `paper/sections/*.tex`: one file per section; this is where text edits go.
- `paper/references.bib`: bibliography.
- `docs/writing-guidelines.md`: full writing conventions.

## Checking your work

- Build: `make editor-pdf` (Docker) or `make pdf` (local TeX). The build must finish without errors.
- Show what changed as a PDF: `make diff-local`, which writes `build/diff.pdf`.
- Do not commit or push unless the author asks.
