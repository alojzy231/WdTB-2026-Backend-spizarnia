---
name: rules-check
description: Run the official project rules for a given lab locally, exactly like CI does (fresh rules from the instructor's template), in an isolated copy, and summarize what fails in plain language. Use before a PR, before a lab-N tag, or when the user asks "czy przejdą reguły", "sprawdź reguły", "rules check".
---

# Rules check

CI replaces `src/test/java/pl/wsb/rules/` with the template's latest copy and runs `mvn verify -Dlab=N`. This skill does the same without touching the working tree.

## Inputs

- Lab number N (default: `<lab>` from `pom.xml`).
- Directory to check (default: the current worktree root).

## Steps

1. Create a scratch copy (`<scratchpad>/rules-check/`), excluding build output, the database and git:
   `rsync -a --delete --exclude target --exclude data --exclude .git --exclude .visual ./ <scratch>/project/`
2. Fetch the fresh rules: `git clone --quiet --depth 1 https://github.com/wkoszela/WdTB-2026-Backend--projectname--.git <scratch>/template` (if it fails, say so and use the local rules, with a warning).
3. Replace the rules in the copy: `rm -rf <scratch>/project/src/test/java/pl/wsb/rules && cp -r <scratch>/template/src/test/java/pl/wsb/rules <scratch>/project/src/test/java/pl/wsb/rules`.
4. Run from the copy: `./mvnw -B -ntp verify -Dlab=N`. Record the exit code separately (never pipe before checking it).
5. Summarize: `python3 ci/summary.py` in the copy prints the same table as the CI Summary tab.
6. Report in Polish: a table of rules (id, name, ✅/❌/⏭), then for each failure the rule's message, the likely cause in the code (file:line) and the fix. Point out if the template's rules differ from the local copy (`/usr/bin/diff -rq`): then `sync-template` is due.

## Rules

- Never modify the real worktree. Never "fix" a rule.
- Distinguish a team test failure from a rule failure in the report.
