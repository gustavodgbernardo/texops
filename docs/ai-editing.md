# Editing with AI assistants

How to let an AI assistant polish your text while you stay in control of every change, without opening a pull request for each edit.

## The idea

Pull requests are for **topics** ("rewrite the introduction"), not for every edit.
While you work on a topic, you run many small local cycles:

```
commit (checkpoint) → AI edits → review (VS Code diff + diff.pdf) → keep / discard parts → commit → …
                                                                                        └─► push → one pull request
```

Local commits are private until you push, so make as many as you like.

## Before you start

- Work on a branch for the topic: `git switch -c rewrite-introduction`.
- Use an assistant that **edits files and shows the changes as a diff** before applying them (e.g. Claude Code in VS Code, GitHub Copilot edits).
  Copying text back and forth from a chat window usually reformats whole paragraphs and makes review harder.
- The repository includes [`AGENTS.md`](../AGENTS.md) (and [`CLAUDE.md`](../CLAUDE.md), which imports it) with the project's editing rules: one sentence per line, change only what was asked, don't touch labels, citations or equations, never invent references.
  Most assistants read these files automatically; if yours does not, paste the rules at the start of the conversation.

## The cycle

### 1. Checkpoint

Commit your current state before asking for changes:

```bash
git commit -am "Draft introduction"
```

Or in VS Code: **Source Control** (`Ctrl+Shift+G`) → message → **Commit**.
If the AI's changes are bad, you can go back to this point.

### 2. Ask for a focused change

Point to a specific file or passage and say what to change, for example:

> Improve the clarity of the second paragraph of `paper/sections/introduction.tex`. Keep the meaning and the citations.

Small, targeted requests produce small diffs.

### 3. Review the changes

**In the editor**: open **Source Control** and click the changed file.
The diff shows each modified sentence on its own line, with the changed words highlighted.

**As a PDF**: `Ctrl+Shift+P` → **Tasks: Run Task** → **texops: diff PDF (since last commit)**.
It builds `build/diff.pdf` (removed text in red, added text in blue) and opens it in a VS Code tab.
From the terminal: `make diff-local`.

### 4. Keep or discard, piece by piece

In the diff view:

| To | Do |
|---|---|
| Keep some changes | Select the lines → right-click → **Stage Selected Ranges** |
| Discard some changes | Select the lines → right-click → **Revert Selected Ranges** |
| Keep the whole file | **+** (Stage Changes) next to the file |
| Discard the whole file | ↶ (Discard Changes) next to the file |

You can also simply edit the text by hand in the diff's right side.

### 5. Commit what you kept

```bash
git commit -m "Clarify introduction, second paragraph"
```

Repeat steps 2–5 as often as needed.

### 6. Open the pull request

When the topic is done:

1. **Tasks: Run Task** → **texops: diff PDF (since main)** to see everything the branch changes.
2. `git push -u origin rewrite-introduction` and open **one** pull request.

Reviewers see the whole topic in the PR's `diff.pdf`; the individual local commits remain available in the PR's *Commits* tab if they want the detail.

## Undoing

| Situation | Command |
|---|---|
| Discard all uncommitted changes to a file | `git restore paper/sections/introduction.tex` |
| Discard all uncommitted changes | `git restore .` |
| Undo the last commit, keep its changes in the files | `git reset --soft HEAD~1` |
| See what a file looked like before | VS Code **Timeline** panel (bottom of the Explorer) |

## Tips

- One sentence per line is what makes all of this readable: a changed sentence is a changed line.
- Ask the assistant to explain its changes when they are not obvious; keep the explanation out of the `.tex` files.
- Check every new or changed citation against `paper/references.bib` and the original source. Assistants can produce plausible but wrong references.
