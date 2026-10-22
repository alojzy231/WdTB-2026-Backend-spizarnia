# spizarnia (WdTB-2026-Backend)

Team project (3 people) for the course "Wprowadzenie do technologii backendowych" (WSB Merito). A fork of the instructor's template `wkoszela/WdTB-2026-Backend--projectname--`. The course pages live in `docs/*.html` (Polish): `lab0N.html` per lab, `wymagania.html`, `reguly.html`, `zespol.html`. Read the relevant lab page before working on a lab.

## Stack

Java 21 (any newer JDK builds it too), Spring Boot 3.5, Maven (use the wrapper `./mvnw`, there is no global `mvn`), Spring Data JPA + H2 in a file (`./data/`, gitignored), Lombok, JUnit 5 + ArchUnit. Teammates work in IntelliJ IDEA.

## Project rules (graded)

- Grading happens on the `lab-N` tag made during class. CI ("Testy i reguły") runs `mvn verify` with the official rules.
- The official rules live in `src/test/java/pl/wsb/rules/`. CI always replaces them with the template's copy, so **never edit them**: a local change proves nothing. The active lab is `<lab>` in `pom.xml`.
- Package layout is checked by the rules (`src/test/java/pl/wsb/rules/core/Project.java`):
  `pl.wsb.spizarnia.<module>.domain` (entities, enums, repositories) · `.application` (services, `@Transactional`) · `.api` (public module contract) · `.web` (`@RestController`, `*Request`/`*Response`) · `.infrastructure` · shared code in `pl.wsb.spizarnia.shared|common|config`.
- `src/main/resources/data.sql` is edited by the whole team and conflicts most often: append rows at the end of your table's section.
- Every team member must be able to explain any part of the code to the instructor. Prefer plain, idiomatic Spring over clever code. Use the `explain` skill to prepare.
- Keep `pom.xml` identity (`artifactId`, `version` with student numbers) and `src/main/resources/static/index.html` (project card) intact unless the task is about them.

## Language

Code identifiers in English. Comments, Javadoc, commit subjects and user-facing text in Polish, matching the existing code.

## Git flow

- **Never work on `main`.** One change = one branch = one PR. `.githooks/` blocks commits and pushes to `main` (`git config core.hooksPath .githooks`, Claude sets it on session start).
- Conventional commits **without scope**, brief: `feat: encja produktu i dane startowe`.
- Commit each logical unit as soon as it is done. Plan the commit split before multi-part work.
- Open PRs with `gh pr create`, body from `.github/pull_request_template.md`. Use `#N` only for real PR or issue references.
- **Agents never merge PRs** (`gh pr merge` is forbidden). The user reviews and merges.
- Before starting a lab, pull template updates with the `sync-template` skill.

## Quality gate

Run Maven on JDK 21, like CI: `export JAVA_HOME=$(/usr/libexec/java_home -v 21)` on macOS (Claude gets it from `.claude/settings.local.json`). Spotless fails on JDK 27.

Before calling anything done, in the worktree:

1. `./mvnw -B -ntp spotless:apply` (formats only files changed against `origin/main`).
2. `./mvnw -B -ntp verify` (compiles, runs team tests and the rules of `<lab>`). Never pipe it before `&&`; check the exit code.
3. For the official, fresh rules of a given lab: the `rules-check` skill.

## Agent workflow

Details and the diagram: `.agents/README.md`.

- Non-trivial work goes through the `ship` skill: `brief` (or `lab` for a whole lab) → implementer lanes in worktrees (`scripts/worktree-new.sh`) → local gate → optional verifiers → PR → **the user merges**.
- `verifier`, `api-verifier` and `visual-verifier` are optional. The orchestrator proposes one when it is worth it and asks the user before spawning it.
- Product and business decisions (domain, entities, endpoints, scope of a lab) belong to the team. Ask with numbered options and a recommended default, never guess.
- Agents report in their fixed formats (DONE / BLOCKED, PASS / FAIL). BLOCKED beats guessing.

## Self-improvement

- Friction goes into `.claude/papercuts/` as one new file per entry, never edited.
- Rules learned from mistakes live in `.claude/LEARNINGS.md` (about 60 lines max). Read it before working.
- Only the `retro` skill turns papercuts into rule changes, and only with the user's approval.

## Runtime and safety

- Shared skills live in `.agents/skills/` (Claude sees them through symlinks in `.claude/skills/`); shared role instructions live in `.agents/roles/`. `.claude/agents/` and `.codex/agents/` are thin adapters.
- Never force-push (`git push --force`, `-f`, `--force-with-lease`). Never rewrite `main` history.
- Never commit secrets, the H2 database (`data/`), `target/` or screenshots (`.visual/`).
- Claude permission rules do not enforce Codex behavior: keep Codex's sandbox and approval policy on.
