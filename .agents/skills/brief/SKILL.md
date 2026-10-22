---
name: brief
description: Turn an idea or task into an approved brief that passes the definition-of-ready gate. Use before any non-trivial change, and as the first stage of `ship`.
---

# Brief

A brief is the only input an implementer gets. If it is vague, the agent guesses. This skill exists to stop that.

## Steps

1. **Interview.** Ask the user about the goal, scope and done state, one decision at a time. Offer numbered options with a recommended default ("1a, 2b" answers are fine). Never decide domain questions yourself: entity names, fields, relations, endpoints, validation rules and sample data belong to the team.
2. **Research facts.** Read the code the change touches, `AGENTS.md` and the lab page (`docs/lab0N.html`). Read the rules that will judge it (`src/test/java/pl/wsb/rules/labN/`, if present). Check every Spring/JPA/Hibernate fact against current docs (Context7 or the official reference). Never write one from memory.
3. **Write** `.agents/briefs/<slug>.md` from the template below.
4. **Gate.** Check every item in "Definition of ready". Fix the gaps or ask about them.
5. **Approve.** Show the brief and get an explicit "go". After approval, the run is autonomous up to an open PR. The user merges.

Briefs live on the feature branch only. `ship` deletes them before the PR, so they never reach `main`.

## Template

```markdown
# <title>

## Goal
<one paragraph: what changes and why; which lab requirement it covers>

## Scope
IN: <bullets>
OUT: <bullets, deliberately excluded>

## Acceptance criteria
1. <observable, testable statement>

## Decisions (made by the team, do not reopen)
- <decision> — <reason>

## Facts
- <Spring/JPA fact> — <doc URL, checked YYYY-MM-DD>

## Rules
- <official rule id and name this must satisfy, e.g. "R2.01 …"> or "none"

## Blast radius
MAY touch: <packages/files>
MUST NOT touch: `src/test/java/pl/wsb/rules/`, <others>

## Lanes
<only for parallel work: lane name → packages; which lane produces a contract the others consume>

## Verification
- `./mvnw -B -ntp verify` → BUILD SUCCESS
- API: <endpoints for the api-verifier, or "none">
- UI: <pages for the visual-verifier, or "none">
```

## Definition of ready

- [ ] Every acceptance criterion is observable and testable.
- [ ] Scope OUT is explicit.
- [ ] Every team decision is recorded under "Decisions"; no domain question is left for the implementer.
- [ ] Every external fact has a doc link and a check date.
- [ ] The rules of the target lab are listed.
- [ ] Blast radius is explicit and excludes `src/test/java/pl/wsb/rules/`.
- [ ] Parallel lanes name their shared additions (entities, `data.sql` sections) up front.
- [ ] Verification commands are concrete.
