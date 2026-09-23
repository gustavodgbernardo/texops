# texops

Reproducible LaTeX writing with Docker, CI-built PDFs and visual diffs on every pull request.

texops is a template for writing papers (or theses, reports, …) the way software is written:

- **Edit** in VS Code with a live PDF preview.
- **Build** inside a Docker image, so every co-author gets the same PDF without installing LaTeX.
- **Review** through pull requests: CI compiles the paper and a [latexdiff](https://ctan.org/pkg/latexdiff) of the changes, and posts links that open both PDFs directly in the browser.

Reviewers don't need to clone anything or install anything: they open the pull request and click the links.

```
VS Code + LaTeX Workshop ──► git push ──► pull request ──► GitHub Actions (Docker)
      (Dev Container)                                          ├─ main.pdf
                                                               └─ diff.pdf  (removed / added text marked)
                                                                    └─ links commented on the PR
```

## Quick start

### 1. Create your paper repository

Click **Use this template** on GitHub, then clone your new repository.

### 2. Choose how to build locally

| Option | Requirements | How |
|---|---|---|
| **VS Code Dev Container** (recommended) | VS Code, Docker, the *Dev Containers* extension | Open the folder and choose **Reopen in Container**. Saving a `.tex` file rebuilds the PDF, shown in a VS Code tab. |
| **Docker only** | Docker, make | `make docker-pdf` → `build/main.pdf` |
| **Local TeX Live** | TeX Live, latexmk, latexdiff | `make pdf` |

The first container build downloads TeX Live and takes a few minutes; later builds are cached.

### 3. Write through pull requests

```bash
git switch -c rewrite-introduction
# edit paper/sections/introduction.tex
git commit -am "Rewrite introduction"
git push -u origin rewrite-introduction
```

Open a pull request. When the build finishes, a comment like this appears:

> ### 📄 PDF preview
> 📄 **Paper (main.pdf)**
> 🔴🔵 **Changes (diff.pdf)**

The comment is updated on every push to the pull request.

## Commands

| Command | Result |
|---|---|
| `make pdf` | `build/main.pdf` |
| `make diff BASE=origin/main` | `build/diff.pdf`, changes since `BASE` |
| `make lint` | `chktex` warnings |
| `make docker-pdf` / `make docker-diff` | Same, inside Docker |
| `make clean` | Remove `build/` |

## Repository layout

```
.
├── paper/
│   ├── main.tex              # document class, packages, \input of each section
│   ├── sections/             # one file per section
│   ├── figures/
│   ├── references.bib
│   └── .latexmkrc
├── scripts/diff.sh           # builds diff.pdf with latexdiff
├── Dockerfile                # TeX environment shared by VS Code, make and CI
├── .devcontainer/            # VS Code Dev Container
├── .vscode/settings.json     # LaTeX Workshop configuration
├── .github/workflows/        # CI: build, publish, comment, clean up
└── docs/writing-guidelines.md
```

## How the PDF preview works

1. On every pull request, [`build.yml`](.github/workflows/build.yml) builds the Docker image (cached between runs), compiles `main.pdf` and runs `scripts/diff.sh` against the base branch.
2. The PDFs are committed to the `pdf-builds` branch under `pr-<number>/`.
3. A bot comment on the pull request links to both files.
4. When the pull request is closed, [`cleanup.yml`](.github/workflows/cleanup.yml) deletes its folder.
5. Pushes to `main` publish the latest paper under `main/main.pdf`.

PDFs are also attached to every workflow run as an artifact.

**Pull requests from forks** receive a read-only token, so they only get the artifact (no `pdf-builds` publishing, no comment).

### Enable GitHub Pages (one-time setup)

GitHub's file view does not reliably render PDFs, so the links should point to GitHub Pages, which serves them as `application/pdf` and lets the browser open them.

1. Merge a first pull request (or push to `main`) so the `pdf-builds` branch exists.
2. Go to **Settings → Pages → Build and deployment**, choose **Deploy from a branch**, branch `pdf-builds`, folder `/ (root)`.

The workflow detects Pages automatically and uses `https://<owner>.github.io/<repo>/pr-<number>/…` links; without Pages it links to the file on the branch.

> **Private repositories:** GitHub Pages sites are public (except on GitHub Enterprise Cloud), even when the repository is private.
> Anyone with the link could open an unpublished paper.
> For papers under review, either keep Pages disabled and use the workflow artifact, or accept that the PDF URLs are public but unlisted.

## Writing conventions

The most important rule: **one sentence per line**. It makes diffs and review comments point to single sentences.
See [docs/writing-guidelines.md](docs/writing-guidelines.md).

## Customizing

- **Document class**: edit `paper/main.tex` (e.g. `IEEEtran`, `elsarticle`, `llncs`). The image includes `texlive-publishers`; for classes distributed by the publisher, place the `.cls`/`.bst` files in `paper/`.
- **Extra LaTeX packages**: add the Debian package to the `Dockerfile` (e.g. `texlive-lang-portuguese`).
- **Bibliography**: `plain` BibTeX by default; `biber` is installed if you prefer biblatex.

## Costs

Everything runs on free tiers: public repositories have unlimited GitHub Actions minutes, and a private repository's build takes a few minutes of the free monthly quota.

## License

The template infrastructure is released under the [MIT License](LICENSE).
Papers written with it belong to their authors and may use any license.
