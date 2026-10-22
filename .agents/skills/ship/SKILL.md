---
name: ship
description: Orchestrate a change end to end - brief, implementer lanes in worktrees, local quality gate, optional verifiers (only after asking), PR for the user to merge, retro. Use when the user asks to build, ship or implement a feature, a fix or a lab.
---

# Ship

You are the orchestrator. You plan, delegate, judge reports and talk to the user. You do not edit app code yourself; delegate to an implementer. You never merge PRs.

## Runtime adapters

- Claude Code: use the named agents in `.claude/agents/`.
- Codex: use the matching custom agent in `.codex/agents/`, with the same inputs. If custom agents are unavailable, start a fresh independent context and instruct it to read `.agents/roles/<role>.md`; never let the implementer verify itself. If independent delegation is unavailable, report BLOCKED.
- Before starting, make sure `git config core.hooksPath` prints `.githooks`; set it if not.

## Pipeline

1. **Brief.** Run the `brief` skill (or `lab` for a whole lab). Nothing starts before the user approves the brief.
2. **Sync.** If the template has news (`git fetch upstream` shows commits not in `main`), suggest running `sync-template` first; lab pages and rules may have changed.
3. **Split.** Read the brief's lanes. Contract-first: a lane that creates entities or a module's `api` others use goes first; its CONTRACT goes verbatim into dependent lanes' prompts, or is committed on their base branch. Lanes that don't depend on each other run in parallel. Lanes touching `data.sql` must own separate table sections.
4. **Worktrees.** One lane = one worktree = one branch, created with `scripts/worktree-new.sh <slug> <branch>`, which prints the lane's port. Never run two agents in one worktree. Each worktree has its own H2 file (`./data/`), so lanes don't share data.
5. **Implement.** Spawn one `implementer` per lane with the brief path, lane, worktree, branch, port, any upstream contract and a lane-unique scratch folder (`<scratchpad>/<brief-slug>/`). BLOCKED → bring its questions to the user, record answers under the brief's "Decisions", resume.
6. **Gate.** Re-run the local gate fresh in the lane's worktree: `./mvnw -B -ntp spotless:apply` then `./mvnw -B -ntp verify` (check the exit code). For lab work also run `rules-check` for the target lab.
7. **Optional checks — ask first.** Decide whether an independent check is worth it:
   - `verifier`: larger diffs, JPA relations, anything graded by tricky rules.
   - `api-verifier`: the diff adds or changes REST endpoints.
   - `visual-verifier`: the diff changes a page (project card, a frontend) or the PR needs screenshots.
   Ask the user in one message which to run, with your recommendation and a one-line reason each. Spawn only what they approve. Never spawn a verifier without asking. FAIL → findings back to the implementer; at most 2 fix rounds, then escalate with the reports.
8. **Integrate.** Several lanes for one PR? Merge them into one branch, re-run the gate there, and check `git merge-tree --write-tree origin/main HEAD`. Merge `origin/main` again right before the PR.
9. **PR.** Delete `.agents/briefs/<slug>.md` in a final `chore:` commit. `git push -u origin <branch>`, then `gh pr create --body-file <file>` with:
   - Title: conventional commit, no scope, brief, Polish subject.
   - Body from `.github/pull_request_template.md`, including "How it works (for the defence)" from the implementers' EXPLAIN output and the verifier tables under "Evidence". Screenshots: list the `.visual/` files and ask the user to drag them into the PR.
   - Grep the body for `#[0-9]+` before sending: only real PR or issue references may use `#N`.
10. **Watch, don't merge.** Run `gh pr checks <number> --watch`. Red "Testy i reguły" → send the failure to the implementer (max 2 rounds). Green → stop. **Never run `gh pr merge`.** The user reviews and merges.
11. **Report.** Tell the user in a few lines: PR link, check status, what to look at in review, verifier tables if any. After they merge, clean up with `scripts/worktree-remove.sh <slug>`.
12. **Retro.** Log a papercut for any friction (see `.claude/papercuts/README.md`). If the inbox has 3+ entries, suggest `retro`.

## Rules

- Interrupt the user only for: brief approval, BLOCKED questions, the optional-check question, escalations after 2 fix rounds, destructive actions.
- Run at most 4 agents at once.
- Never commit or push to `main`, never force-push, never merge.
