# Review workflow

How authors propose changes and how reviewers (co-authors, advisors) review them.
Reviewers only need a GitHub account and a browser.

## For authors

1. **Create a branch** for one topic:

   ```bash
   git switch main && git pull
   git switch -c rewrite-introduction
   ```

2. **Edit and build locally** (see [vscode.md](vscode.md)). Keep one sentence per line ([writing-guidelines.md](writing-guidelines.md)).

3. **Commit and push**:

   ```bash
   git commit -am "Rewrite introduction"
   git push -u origin rewrite-introduction
   ```

4. **Open a pull request** on GitHub and fill in the template.
   After about a minute, a bot comment links to:
   - `main.pdf`: the paper as it would be after the merge;
   - `diff.pdf`: the same paper with removed text in red and added text in blue.

5. **Ask for review**: add the reviewer in *Reviewers* (right side of the PR).

6. **Address comments**: edit, commit and push to the same branch.
   The PDFs and the bot comment update automatically.
   Reply to each comment (e.g. "Done in `abc1234`") and click **Resolve conversation**.

7. **Merge** when approved. The PR's PDFs are deleted and `main/main.pdf` is updated.

## For reviewers

1. Open the pull request link you received.
2. **Read the changes** through the bot comment: `diff.pdf` shows exactly what changed; `main.pdf` shows the result.
3. **Comment**:
   - *On a specific sentence*: tab **Files changed** → hover the line in the `.tex` file → click **+** → write → **Start a review**.
     Use **Add a suggestion** (±icon) to propose a new wording that the author can accept with one click.
   - *General comments*: tab **Conversation**, box at the bottom.
4. **Finish the review**: **Review changes** (top right of *Files changed*) → choose:
   - **Comment**: general feedback;
   - **Approve**: ready to merge;
   - **Request changes**: must be addressed before merging.
5. When the author pushes new commits, open the updated `diff.pdf` or use **Files changed → Changes since your last review**.

## Conventions

- One topic per pull request, small enough to review in one sitting.
- Name branches after the task: `rewrite-introduction`, `fix-figure-1`, `reviewer-2-comments`.
- Resolve a conversation only after the change is pushed (or after agreeing no change is needed).
- Do not push directly to `main`; everything goes through a pull request.
  To enforce this, enable a branch protection rule for `main` in **Settings → Branches** requiring a pull request (and, optionally, one approval).
