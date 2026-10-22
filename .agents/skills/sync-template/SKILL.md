---
name: sync-template
description: Bring the instructor's template updates (lab pages, rules, CI) into the team repo through a branch and PR instead of pushing to main. Use at the start of each lab, when "Sync fork" is needed, or when the user says "zsynchronizuj z szablonem", "sync template", "nowe materiały".
---

# Sync template

The course says "Sync fork → Update branch" on GitHub. Here `main` only changes through PRs, so updates go through a branch.

## Steps

1. **Remote.** Ensure `upstream` points at the template: `git remote get-url upstream || git remote add upstream https://github.com/wkoszela/WdTB-2026-Backend--projectname--.git`. Then `git fetch upstream` and `git fetch origin`.
2. **Anything new?** `git log --oneline origin/main..upstream/main`. Nothing → report "up to date" and stop. Otherwise list the commits for the user in a few lines (new lab pages, rule changes, CI changes).
3. **Branch.** In a new worktree (`scripts/worktree-new.sh sync-template-<YYYY-MM-DD>`), run `git merge upstream/main`. Merge, never rebase.
4. **Conflicts.** Resolve by ownership:
   - Template owns: `docs/`, `ci/`, `.github/workflows/`, `src/test/java/pl/wsb/rules/`, `README.md` → take theirs.
   - Team owns: `pom.xml` identity (`artifactId`, `version`, `<lab>`, team plugins), `src/main/**` (including `data.sql`, `static/index.html`), AI setup files → keep ours, but merge in new template dependencies or properties.
   - Anything unclear → ask the user, showing both sides.
   Finish with `git merge --continue`, keeping the default merge message.
5. **Gate.** `./mvnw -B -ntp verify`, then `rules-check` for the current `<lab>`.
6. **PR.** `git push -u origin <branch>`, `gh pr create` with title `chore: synchronizacja z szablonem`, the commit list and any conflict decisions in the body. The user merges it with a merge commit (not squash), so the template history stays shared and the next sync has no repeat conflicts.

## Rules

- Never push to `main`, never force-push.
- If the user prefers GitHub's "Sync fork" button, tell them it updates `main` directly, which needs the branch rule bypass (repo owner only).
