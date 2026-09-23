# Writing in VS Code

This guide sets up VS Code to edit the paper with a live PDF preview.
TeX always runs inside the project's Docker image, so you never need to install LaTeX.

## Contents

- [Requirements](#requirements)
- [Choose a setup](#choose-a-setup)
- [Setup A: open the project folder (recommended)](#setup-a-open-the-project-folder-recommended)
- [Setup B: project inside a larger workspace folder](#setup-b-project-inside-a-larger-workspace-folder)
- [Setup C: Dev Container](#setup-c-dev-container)
- [Daily use](#daily-use)
- [Troubleshooting](#troubleshooting)

## Requirements

| Tool | Why | Check |
|---|---|---|
| [VS Code](https://code.visualstudio.com/) | Editor | `code --version` |
| [Docker](https://docs.docker.com/get-docker/) | Runs TeX Live | `docker run --rm hello-world` works **without** `sudo` |
| `make` | Build commands | `make --version` (Linux/macOS; on Windows use WSL) |
| Extension **LaTeX Workshop** (`James-Yu.latex-workshop`) | Build on save, PDF tab, SyncTeX | `code --install-extension James-Yu.latex-workshop` |
| Extension **Dev Containers** (`ms-vscode-remote.remote-containers`) | Only for setup C | `code --install-extension ms-vscode-remote.remote-containers` |
| Extension **LTeX+** (`ltex-plus.vscode-ltex-plus`), optional | English grammar and spelling | `code --install-extension ltex-plus.vscode-ltex-plus` |

On Linux, if Docker needs `sudo`, add yourself to the `docker` group and log in again:

```bash
sudo usermod -aG docker "$USER"
```

## Choose a setup

| | What you open in VS Code | TeX runs in | Extra configuration |
|---|---|---|---|
| **A** | The project folder itself | Docker, started by `make` | None |
| **B** | A parent folder with several projects (e.g. `~/repos`) | Docker, started by `make` | Copy settings once into the parent folder |
| **C** | The project folder, reopened inside the container | The container VS Code runs in | None |

All three use the same Docker image, so they produce the same PDF as CI.

## Setup A: open the project folder (recommended)

1. **File → Open Folder…** and select the project folder (the one that contains `paper/` and `Makefile`).
2. Open `paper/main.tex` or any file in `paper/sections/`.
3. Save the file (`Ctrl+S`). The first build creates the Docker image and takes a few minutes; later builds take seconds.
4. Open the PDF with `Ctrl+Alt+V` (or the *View LaTeX PDF* icon, top right).

This works because the project ships a [`.vscode/settings.json`](../.vscode/settings.json) that makes LaTeX Workshop run `make editor-pdf`.

## Setup B: project inside a larger workspace folder

VS Code only reads `.vscode/settings.json` from the folder you opened.
If you open a parent folder (for example `~/repos`, with this project in `~/repos/my-paper`), the project's settings are ignored and LaTeX Workshop falls back to its defaults, which need a local TeX install.

Do this once:

1. Create or edit `.vscode/settings.json` **in the parent folder** (e.g. `~/repos/.vscode/settings.json`).
2. Add the entries below. Keep any settings that are already there.

```jsonc
{
  "latex-workshop.latex.tools": [
    {
      "name": "make-editor-pdf",
      "command": "make",
      "args": ["-C", "%DIR%/..", "editor-pdf"],
      "env": {}
    },
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "-pdf", "-outdir=%OUTDIR%", "%DOC%"],
      "env": {}
    }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "texops", "tools": ["make-editor-pdf"] },
    { "name": "latexmk", "tools": ["latexmk"] }
  ],
  "latex-workshop.latex.recipe.default": "texops",
  "latex-workshop.latex.outDir": "%DIR%/../build",
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab"
}
```

3. To get the diff PDF tasks as well, copy [`.vscode/tasks.json`](../.vscode/tasks.json) to the parent folder (`~/repos/.vscode/tasks.json`). The tasks find the project from the open file, so they work for every texops project under the parent folder.
4. Reload VS Code: `Ctrl+Shift+P` → **Developer: Reload Window**.

The paths are relative to the edited paper (`%DIR%` is the folder of `main.tex`), so the same settings work for every texops project under the parent folder.
For other LaTeX projects in the same parent folder that do not follow this layout, pick the **latexmk** recipe in the TeX side panel.

## Setup C: Dev Container

VS Code itself runs inside the container, together with TeX and the extensions.

1. Install the **Dev Containers** extension.
2. Open the project folder (the Dev Container is defined in [`.devcontainer/`](../.devcontainer/), so it must be the folder you open).
3. Click **Reopen in Container** in the notification, or `Ctrl+Shift+P` → **Dev Containers: Reopen in Container**.
4. The bottom-left corner shows **Dev Container: texops**. Use it as in setup A.

`make editor-pdf` notices there is no Docker inside the container and calls `latexmk` directly.

## Daily use

| Action | How |
|---|---|
| Build | Save any `.tex` file (`Ctrl+S`); or `Ctrl+Alt+B` |
| Open the PDF | `Ctrl+Alt+V` (opens in a tab; drag it to the side) |
| PDF → source | `Ctrl+Click` on the PDF |
| Source → PDF | `Ctrl+Alt+J` on a line of `.tex` |
| See errors | **Problems** panel (`Ctrl+Shift+M`) or the LaTeX Workshop output |
| Diff PDF of your uncommitted changes | `Ctrl+Shift+P` → **Tasks: Run Task** → **texops: diff PDF (since last commit)** |
| Diff PDF of the whole branch | **Tasks: Run Task** → **texops: diff PDF (since main)** |
| Clean | Terminal: `make clean` |

Every section file begins with `% !TEX root = ../main.tex`, so saving a section builds the whole paper.
Keep that line when you add sections.

Git actions (branch, commit, push) can be done in the **Source Control** panel (`Ctrl+Shift+G`) or in the terminal.
See [review-workflow.md](review-workflow.md) for the pull request flow and [ai-editing.md](ai-editing.md) for reviewing edits made by AI assistants.

## Troubleshooting

| Problem | Fix |
|---|---|
| *"Reopen in Container" does not appear* | Install the Dev Containers extension and make sure you opened the project folder, not a parent folder. |
| Build fails with `latexmk: command not found` | You are in setup B without the parent settings, or the **latexmk** recipe is selected. Add the settings above and choose the **texops** recipe. |
| Build fails with `permission denied ... docker.sock` | Docker needs `sudo`; add yourself to the `docker` group (see [Requirements](#requirements)). |
| First build is very slow | Expected: it downloads TeX Live once. Later builds reuse the image. |
| `Ctrl+Click` on the PDF does nothing | Rebuild once (old `synctex.gz` files may point to container paths), and check the PDF tab was opened from LaTeX Workshop. |
| The PDF does not refresh | Check the build finished without errors; the tab reloads automatically when `build/main.pdf` changes. |
| A package is missing (`File 'xyz.sty' not found`) | Add the Debian package that provides it to the `Dockerfile` (search on [packages.debian.org](https://packages.debian.org/)); it is picked up on the next build. |
