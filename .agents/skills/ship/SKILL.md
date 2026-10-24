---
name: ship
description: Orchestrate a change end to end - brief, implementer on main, local quality gate, optional verifiers (only after asking), push to main, watch CI, retro. Use when the user asks to build, ship or implement a feature, a fix or a lab.
---

# Ship

You are the orchestrator. You plan, delegate, judge reports and talk to the user. You do not edit app code yourself; delegate to an implementer. Work lands directly on `main`, as the course requires: no branches, no PRs.

## Runtime adapters

- Claude Code: use the named agents in `.claude/agents/`.
- Codex: use the matching custom agent in `.codex/agents/`, with the same inputs. If custom agents are unavailable, start a fresh independent context and instruct it to read `.agents/roles/<role>.md`; never let the implementer verify itself. If independent delegation is unavailable, report BLOCKED.

## Pipeline

1. **Brief.** Run the `brief` skill (or `lab` for a whole lab). Nothing starts before the user approves the brief.
2. **Sync.** If the template has news (`git fetch upstream` shows commits not in `main`), suggest running `sync-template` first; lab pages and rules may have changed.
3. **Start clean.** `git status` must be clean and the branch must be `main`; then `git pull --rebase origin main`. Uncommitted changes that are not yours → ask the user before touching them.
4. **Steps.** Read the brief's steps. Contract-first: a step that creates entities or a module's `api` others use goes first; its CONTRACT goes verbatim into the next step's prompt. Steps run one at a time: there is one working tree, so never run two implementers at once.
5. **Implement.** Spawn one `implementer` per step with the brief path, the step and a scratch folder (`<scratchpad>/<brief-slug>/`). It commits on `main` but never pushes. BLOCKED → bring its questions to the user, record answers under the brief's "Decisions", resume.
6. **Gate.** Re-run the local gate fresh: `./mvnw -B -ntp spotless:apply` then `./mvnw -B -ntp verify` (check the exit code). For lab work also run `rules-check` for the target lab.
7. **Optional checks — ask first.** Decide whether an independent check is worth it:
   - `verifier`: larger diffs, JPA relations, anything graded by tricky rules.
   - `api-verifier`: the diff adds or changes REST endpoints.
   - `visual-verifier`: the diff changes a page (project card, a frontend).
   Ask the user in one message which to run, with your recommendation and a one-line reason each. Spawn only what they approve, passing the unpushed commit range (`origin/main..HEAD`). Never spawn a verifier without asking. FAIL → findings back to the implementer; at most 2 fix rounds, then escalate with the reports.
8. **Push.** Delete `.agents/briefs/<slug>.md` (it is never committed). `git pull --rebase origin main`; if teammates pushed, re-run the gate. A rebase conflict (often `data.sql`) → resolve by keeping both sides' rows, or ask the user when unsure. Then `git push origin main`. Never force-push: a rejected push means pull and retry.
9. **Watch CI.** `gh run list --branch main --limit 1`, then `gh run watch <id> --exit-status`. Red "Testy i reguły" → send the failure to the implementer, fix with a new commit and push again (max 2 rounds), then escalate.
10. **Report.** Tell the user in a few lines: pushed commits, CI status, what to look at, verifier tables and screenshot paths (`.visual/`) if any. Suggest `explain` for the touched modules.
11. **Retro.** Log a papercut for any friction (see `.claude/papercuts/README.md`). If the inbox has 3+ entries, suggest `retro`.

## Rules

- Interrupt the user only for: brief approval, BLOCKED questions, the optional-check question, escalations after 2 fix rounds, destructive actions.
- Run at most one implementer at a time; verifiers may run in parallel (they don't write code).
- Push only after a green local gate. Never force-push, never rewrite pushed history, never create or push `lab-N` tags.
