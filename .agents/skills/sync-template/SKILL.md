---
name: sync-template
description: Bring the instructor's template updates (lab pages, rules, CI) into the team repo by merging upstream into main locally, checking it and pushing. Use at the start of each lab, when "Sync fork" is needed, or when the user says "zsynchronizuj z szablonem", "sync template", "nowe materiały".
---

# Sync template

The course says "Sync fork → Update branch" on GitHub. That button works too, but it fails on conflicts and skips the local check, so this skill merges locally instead.

## Steps

1. **Remote.** Ensure `upstream` points at the template: `git remote get-url upstream || git remote add upstream https://github.com/wkoszela/WdTB-2026-Backend--projectname--.git`. Then `git fetch upstream` and `git fetch origin`.
2. **Anything new?** `git log --oneline origin/main..upstream/main`. Nothing → report "up to date" and stop. Otherwise list the commits for the user in a few lines (new lab pages, rule changes, CI changes).
3. **Merge.** On a clean `main`: `git pull --rebase origin main`, then `git merge upstream/main`. Merge, never rebase: the template history must stay shared, so the next sync has no repeat conflicts.
4. **Conflicts.** Resolve by ownership:
   - Template owns: `docs/`, `ci/`, `.github/workflows/`, `src/test/java/pl/wsb/rules/`, `README.md` → take theirs.
   - Team owns: `pom.xml` identity (`artifactId`, `version`, `<lab>`, team plugins), `src/main/**` (including `data.sql`, `static/index.html`), AI setup files → keep ours, but merge in new template dependencies or properties.
   - Anything unclear → ask the user, showing both sides.
   Finish with `git merge --continue`, keeping the default merge message.
5. **Gate.** `./mvnw -B -ntp verify`, then `rules-check` for the current `<lab>`. Red → fix it in a separate commit, or ask the user.
6. **Push.** `git push origin main`, then watch CI (`gh run watch <id> --exit-status`). Report the merged commits and any conflict decisions.

## Rules

- Never force-push, never rebase the merge commit.
