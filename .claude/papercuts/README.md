# Papercuts inbox

Friction from agent runs, waiting for the next `retro`. Small, raw, cheap to write.

## Rules

- **One file per entry**, never edit an existing one, so parallel sessions can't overwrite each other.
- Filename: `YYYY-MM-DD-<short-slug>.md`.
- Content: one line.

  ```
  <task or commit> · <category> · <what happened> → <what would have prevented it>
  ```

- Categories: `spec-gap` (the brief missed something), `agent-guessed`, `verifier-noise`, `verifier-miss`, `rules-miss` (official rules failed after our gate passed), `missing-skill`, `tooling`, `other`.
- Anyone writes here: the orchestrator, agents (through their NOTES / PAPERCUTS output) and the team.
- Only `retro` deletes entries, after folding them into a rule.
