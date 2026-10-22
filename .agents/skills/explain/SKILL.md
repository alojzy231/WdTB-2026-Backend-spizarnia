---
name: explain
description: Explain a piece of the project (a file, a module, a PR, an endpoint flow) in Polish so any team member can defend it in front of the instructor; can quiz the user. Use when the user says "wytłumacz", "explain", "jak to działa", "przygotuj do obrony" or after a lab's PRs.
---

# Explain

At grading the instructor may ask any team member to explain any part of the code or to make a small change. This skill prepares for that.

## Inputs

- What to explain: a path, a module (`pl.wsb.spizarnia.<module>`), a PR number or an endpoint. Default: the diff of the current branch against `origin/main`.
- Mode: `explain` (default) or `quiz`.

## Explain mode

Answer in Polish, plain language, no jargon without a one-line definition:

1. **W jednym zdaniu:** what this code does for the user.
2. **Przepływ:** request → controller → service → repository → database (or the relevant part), with file:line for each hop. A small Mermaid diagram if there are 3+ hops.
3. **Pojęcia Springa/JPA:** each annotation or concept used (`@Entity`, `@ManyToOne`, `@Transactional`, `@Valid`, `ProblemDetail`, ...): what it does here and what would break without it.
4. **Dlaczego tak:** the design choices and one plausible alternative.
5. **Pytania prowadzącego:** 5 likely questions with short answers.
6. **Drobna zmiana:** one realistic small change the instructor could ask for (add a field, a validation, a query) and the exact steps to do it.

## Quiz mode

Ask the questions one at a time, wait for the user's answer, then correct or confirm it with a pointer to the code. End with a short list of what to revise.

## Rules

- Read the code before explaining; never describe what you expect it to do.
- Do not change code in this skill.
