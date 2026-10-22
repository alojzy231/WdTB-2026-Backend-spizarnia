#!/usr/bin/env bash
# PreToolUse hook for Bash: blocks merging PRs, force-pushing and pushing to main.
# The user merges every PR; main changes only through merged PRs. Exit 2 = block with a message to Claude.
set -uo pipefail

command="$(jq -r '.tool_input.command // empty')"
[ -z "$command" ] && exit 0

block() {
  echo "Blocked by .claude/hooks/guard-git.sh: $1" >&2
  exit 2
}

if grep -Eq '(^|[^[:alnum:]_-])gh[[:space:]]+pr[[:space:]]+merge' <<<"$command"; then
  block "agents never merge PRs; the user reviews and merges."
fi

if grep -Eq 'git[[:space:]].*push' <<<"$command"; then
  if grep -Eq '(^|[[:space:]])(-f|--force|--force-with-lease|--force-if-includes)([[:space:]=]|$)|[[:space:]]\+[^[:space:]]+' <<<"$command"; then
    block "force-push is forbidden."
  fi
  if grep -Eq 'push.*([[:space:]]|:)main([[:space:]]|$)' <<<"$command"; then
    block "pushing to main is forbidden; push a branch and open a PR."
  fi
fi
exit 0
