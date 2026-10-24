---
name: retro
description: Self-improvement loop - harvest papercuts, spot repeated mistakes, and propose concrete diffs to agents, skills, AGENTS.md or LEARNINGS.md for the user to approve. Use after a ship run, when the papercuts inbox has 3+ entries, or when the user says "retro".
---

# Retro

The goal: a mistake made twice becomes a rule, so it isn't made a third time. A rule that stops paying off gets removed.

## 1. Harvest

- Every file in `.claude/papercuts/` except `README.md`.
- Every file in `.claude/visual/caveats/` except `README.md`. Fold the useful ones into `.claude/visual/CAVEATS.md` and delete them in the retro commit.
- Recent history on `main` (`git log --oneline -30`): follow-up `fix:` commits after agent work and failed CI runs (`gh run list --branch main --status failure`) show what the user had to correct.
- The last retro date: `git log -1 --format=%cs --grep "^fix: apply retro"`.

## 2. Group

Cluster findings by root cause, not by symptom. Act on a cluster only if:
- it repeats (2+ entries), or
- one occurrence was severe (failed rules on a `lab-N` tag, broke `main`, lost work).

Everything else stays in the inbox for the next retro.

## 3. Propose

For each cluster, propose the smallest diff to the place that would have prevented it:

| Root cause | Where the fix goes |
| --- | --- |
| Agent guessed or skipped a step | `.agents/roles/<agent>.md` |
| Brief was missing something | the gate in `.agents/skills/brief/SKILL.md` |
| Orchestration went wrong | `.agents/skills/ship/SKILL.md` |
| Lab requirement misread | `.agents/skills/lab/SKILL.md` |
| A codebase or Spring pitfall | `.claude/LEARNINGS.md` |
| Something mechanical | a git hook, a Claude/Codex hook, a team test or a CI step (better than prose) |

Prefer mechanical enforcement over a written rule. Also propose deleting rules that never fire, and scrapping an agent when the data shows it adds nothing.

Show each proposal as a diff with its evidence. Let the user approve, edit or reject each one.

## 4. Apply

- Apply only the approved diffs. The user is the single writer of rules.
- Keep `.claude/LEARNINGS.md` under its ~60-line cap: to add a rule when it's full, merge or remove another.
- Delete the folded papercut files in the same commit.
- Commit on `main`: `fix: apply retro learnings`, then push.
