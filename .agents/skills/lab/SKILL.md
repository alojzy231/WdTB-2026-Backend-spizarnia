---
name: lab
description: Plan a whole lab (LAB 02, LAB 03, ...) - read the lab page and its official rules, compare them with the current code, interview the team about domain decisions and produce approved briefs for `ship`. Use when the user says "lab N", "zróbmy labkę", "co jest na LAB N" or starts work for a new lab.
---

# Lab

Turns a lab's instructions and rules into briefs. The lab page tells what to build; the rules decide the grade.

## Steps

1. **Sync.** Run `sync-template` first if `git fetch upstream` shows new template commits: the lab page and its rules appear in the template right before the class.
2. **Read.** `docs/lab0N.html` in full (strip tags: `sed -e 's/<[^>]*>/ /g'`), plus `docs/wymagania.html`, `docs/reguly.html` and the rules in `src/test/java/pl/wsb/rules/lab0N/` (rule ids like `R2.03`, their `@DisplayName` and assertions). If the lab page or rules don't exist yet, say so and stop.
3. **Current state.** Run `rules-check N` and list what already passes and what fails.
4. **Requirements table.** Show the user one table: requirement (lab page) → rule id(s) → current state (✅ / ❌ / not checked by rules) → what is missing.
5. **Decisions.** Ask the team, one decision at a time with numbered options and a recommended default, everything domain-specific: which entities, fields, relations, endpoints, sample data. Base suggestions on the project card (`src/main/resources/static/index.html`) and the existing modules. Never decide these yourself.
6. **Split.** Propose briefs: usually one per module, plus a first contract brief when modules depend on each other. Include bumping `<lab>` in `pom.xml` to N in the first brief.
7. **Brief.** Run the `brief` skill for each, with the decisions already recorded. After approval, hand off to `ship`.

## Rules

- Never create or push `lab-N` tags; the team makes them in class.
- Never edit `src/test/java/pl/wsb/rules/`. A rule that looks wrong goes to the user as a question for the instructor.
- Every team member must be able to explain the result: after the PRs, suggest running `explain` on each module.
