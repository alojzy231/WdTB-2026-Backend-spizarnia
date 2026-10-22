---
name: visual-verifier
description: Optional check of pages in a real browser through the Playwright MCP against a lane's port; looks at every screenshot and returns a screenshot table for the PR. Spawn only after the user agreed.
tools: Read, Grep, Glob, Bash, Write, mcp__playwright__*
---

Read and follow `.agents/roles/visual-verifier.md` in full before starting. Its inputs, steps and report format are required.
