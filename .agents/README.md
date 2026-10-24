# Agentic workflow

How work gets done in this repo with Claude Code or Codex, and why it is set up this way.

## Why

A team of three, a graded lab every week, official rules in CI, and an instructor who may ask anyone to explain any line. The course has everyone commit straight to `main`, so the setup needs:

1. **A green gate before every push.** `main` is the only branch, so nothing reaches it without a local `verify` and the official rules.
2. **Rules first.** The official rules decide the grade, so they are checked locally before every push.
3. **Understanding.** `explain` prepares each person for the defence.
4. **Memory.** A mistake made once should not be made again.

## Pipeline

```mermaid
flowchart TD
    idea([Task or new lab]) --> sync{template has news?}
    sync -->|yes| synct[sync-template<br/>merge upstream into main]
    sync -->|no| lab
    synct --> lab[lab skill<br/>lab page + rules → decisions]
    lab --> brief[brief skill<br/>definition-of-ready gate]
    brief -->|user approves| split[ship: split into steps<br/>contract-first]
    split --> impl[implementer, one at a time<br/>commits on main, no push]
    impl --> gate[local gate<br/>spotless + mvnw verify + rules-check]
    gate -->|fail| impl
    gate --> ask{orchestrator: worth an<br/>independent check?}
    ask -->|asks user, user agrees| verifiers[verifier · api-verifier ·<br/>visual-verifier]
    verifiers -->|FAIL, max 2 rounds| impl
    ask -->|no| push
    verifiers -->|PASS| push[pull --rebase + push to main]
    push --> ci{CI: Testy i reguły}
    ci -->|red| impl
    ci -->|green| explain[explain: prepare the team]

    impl -. friction .-> papercuts[(.claude/papercuts)]
    verifiers -. misses / noise .-> papercuts
    papercuts --> retro[retro skill]
    retro -->|user approves diff| rules[roles · skills ·<br/>LEARNINGS.md · hooks]
```

## The pieces

| Piece | Where | Job |
| --- | --- | --- |
| `lab` skill | `.agents/skills/lab` | Reads a lab page and its rules, shows what is missing, asks the team the domain decisions, produces briefs. |
| `brief` skill | `.agents/skills/brief` | Writes `.agents/briefs/<slug>.md` (never committed). Nothing starts until it passes the definition-of-ready gate. |
| `ship` skill | `.agents/skills/ship` | The orchestrator: steps, gate, asks before verifiers, pushes to `main`, watches CI. |
| `rules-check` skill | `.agents/skills/rules-check` | Runs the template's fresh rules for lab N in an isolated copy, like CI. |
| `sync-template` skill | `.agents/skills/sync-template` | Merges the instructor's template updates into `main` locally, checks and pushes. |
| `explain` skill | `.agents/skills/explain` | Explains code in Polish, with likely instructor questions; quiz mode. |
| `retro` skill | `.agents/skills/retro` | Turns repeated papercuts into rule changes, with the user's approval. |
| `implementer` | `.agents/roles/implementer.md` | Builds one step on `main`, commits, never pushes; reports DONE (with defence notes) or BLOCKED. |
| `verifier` | `.agents/roles/verifier.md` | Optional, read-only: criteria → code + test, scope, package rules, JPA pitfalls, re-runs the gate. |
| `api-verifier` | `.agents/roles/api-verifier.md` | Optional: calls the running app's endpoints (port 8090) with curl, returns a table. |
| `visual-verifier` | `.agents/roles/visual-verifier.md` | Optional: Playwright MCP screenshots of pages (port 8090) into `.visual/`. |

Optional verifiers run only after the orchestrator asks and the user agrees. Agents run the app on port 8090 so it never clashes with a teammate's app on 8080.

## Guardrails

- **Claude hooks** (`.claude/settings.json`): a guard blocks force-push (it checks command segments, so a heredoc line that itself starts with one is blocked too — write those files with the editor tool); every edited `.java` file is formatted with Spotless; a retro reminder appears when 3+ papercuts wait.
- **Codex hooks** (`.codex/hooks.json`): Spotless formatting after `apply_patch`, retro reminder. The force-push ban is policy in `AGENTS.md` plus Codex's own approval prompts.
- **Push discipline:** agents push only after a green local gate, and `git pull --rebase` first, because teammates push to `main` too.
- **CI** ("Testy i reguły") runs `mvn verify` with the official rules on every push to `main`.

## Self-improvement loop

1. **Capture.** Friction becomes one file in `.claude/papercuts/`, never an edit, so parallel sessions don't conflict.
2. **Remind.** Hooks remind when 3+ papercuts wait.
3. **Fold.** `retro` groups them by root cause and proposes the smallest fix; mechanical enforcement beats prose.
4. **Approve.** The user accepts, edits or rejects each diff.
5. **Prune.** `LEARNINGS.md` stays under ~60 lines.

## One-time setup

1. **JDK 21** (like CI); Spotless fails on newer JDKs. On macOS: `export JAVA_HOME=$(/usr/libexec/java_home -v 21)` for Codex and terminals. For Claude put it in the gitignored `.claude/settings.local.json`:
   ```json
   { "env": { "JAVA_HOME": "/path/to/jdk-21" } }
   ```
2. **Claude Code:** start `claude` in the repo root and approve the `playwright` MCP server. Skills and agents load from `.claude/skills` and `.claude/agents`.
3. **Codex:** start `codex` in the repo root and trust the project (trust is local). Codex reads `AGENTS.md`, the skills in `.agents/skills/`, the agents in `.codex/agents/` and the MCP in `.codex/config.toml`. Open `/hooks` and trust the hooks.
4. **GitHub CLI:** `gh auth login`.
5. **Playwright:** on first use it may ask for `npx playwright install chromium`.

Teammates who only use IntelliJ need nothing extra: *Git → Pull*, commit and push to `main`, as the course describes.
