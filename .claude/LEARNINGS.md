# Learnings

Rules learned from real mistakes. Every agent reads this before working.

- Format: `- <symptom> → <fix>`, one line each, grouped by area.
- Cap: about 60 lines. To add a rule when full, merge or remove one.
- Keep a rule only if removing it would cause mistakes again.
- Only the `retro` skill changes this file, with the user's approval.

## Tooling

- `git`, `diff`, `grep` and `curl` output can come back rewritten or fail under the RTK shell wrapper → use `/usr/bin/git --no-pager …`, `/usr/bin/diff`, `/usr/bin/grep`, `/usr/bin/curl`, `/usr/sbin/lsof`.
- RTK rewrote `gh pr edit --help` to "ok edited", so `--attach` looked missing → read CLI help through `gh help <command>` or `/usr/bin/grep`, never conclude a flag is missing from rewritten output.
- `cmd | tail && git commit` committed a failure, because the pipe hid the exit code → never pipe a gate command before `&&`; use `set -o pipefail` or check `$?` separately.
- zsh expands a leading `=` (`echo =====` → "==== not found") and ties `path` to `PATH` → quote separators (`echo "---"`) and never name a shell variable `path`.
- `pkill -f spring-boot` also kills other worktrees' apps → stop an app by its port: `/usr/sbin/lsof -ti tcp:<port> | xargs kill`.
- There is no global `mvn` → always `./mvnw` from the worktree root.

## Project

- Editing `src/test/java/pl/wsb/rules/` changes nothing: CI replaces it with the template's copy → fix the code, or report a wrong rule to the instructor.
