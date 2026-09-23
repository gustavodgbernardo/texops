# Writing guidelines

These conventions keep diffs small and reviews easy.

## One sentence per line

Put each sentence on its own line.
LaTeX joins consecutive lines into the same paragraph, so the PDF is unchanged, but a diff now shows exactly which sentence changed instead of the whole paragraph.

```latex
% Good
Intrusion detection systems are usually evaluated on static datasets.
This limits their connection with real operational conditions.

% Avoid
Intrusion detection systems are usually evaluated on static datasets. This limits their connection with real operational conditions.
```

A blank line still starts a new paragraph.

## One file per section

Keep each section in `paper/sections/<name>.tex` and include it from `main.tex` with `\input`.
Pull requests then touch only the files they are about.

## Labels and references

- Use prefixes: `sec:`, `fig:`, `tab:`, `eq:`.
- Reference with a non-breaking space: `Section~\ref{sec:method}`, `\cite{key}` after `~`.

## Figures

- Put image files in `paper/figures/` (PDF or PNG).
- Prefer vector formats (PDF, TikZ) so figures stay sharp.

## Bibliography

- Keep all entries in `paper/references.bib`.
- If you use Zotero, the Better BibTeX plugin can export and update this file automatically.

## Pull requests

- One topic per pull request (e.g. "rewrite introduction", "address reviewer 2").
- Review the linked `diff.pdf` before asking for review.
- Reviewers can comment on lines of the `.tex` files or leave a general comment based on the PDF.
