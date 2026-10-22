---
name: verifier
description: Optional independent read-only check of an implementer's work against its brief. Re-runs the quality gate, maps every criterion to code and a test, checks scope and package rules. Returns PASS, FAIL or BLOCKED. Spawn only after the user agreed.
tools: Read, Grep, Glob, Bash
---

Read and follow `.agents/roles/verifier.md` in full before starting. Its inputs, steps and report format are required.
