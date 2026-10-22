#!/usr/bin/env bash
# PreToolUse hook for Bash: blocks merging PRs, force-pushing and pushing to main.
# The user merges every PR; main changes only through merged PRs. Exit 2 = block with a message to Claude.
# Checks only segments that start with the command, so text mentioning it (heredocs, commit messages) passes.
set -uo pipefail

command="$(jq -r '.tool_input.command // empty')"
[ -z "$command" ] && exit 0

block() {
  echo "Blocked by .claude/hooks/guard-git.sh: $1" >&2
  exit 2
}

# One segment per line: split on newlines, ;, &&, || and |.
segments="$(printf '%s\n' "$command" | sed -E 's/(&&|\|\||;|\|)/\n/g')"

while IFS= read -r segment; do
  # Drop leading whitespace, env assignments (FOO=1) and `command`/paths before the binary.
  segment="$(sed -E 's/^[[:space:](]*//; s/^([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*//; s/^command[[:space:]]+//; s#^[^[:space:]]*/(git|gh)([[:space:]])#\1\2#' <<<"$segment")"

  if grep -Eq '^gh[[:space:]]+pr[[:space:]]+merge([[:space:]]|$)' <<<"$segment"; then
    block "agents never merge PRs; the user reviews and merges."
  fi

  if grep -Eq '^git([[:space:]]+-[^[:space:]]+([[:space:]]+[^-][^[:space:]]*)?)*[[:space:]]+push([[:space:]]|$)' <<<"$segment"; then
    if grep -Eq '[[:space:]](-f|--force|--force-with-lease|--force-if-includes)([[:space:]=]|$)|[[:space:]]\+[^[:space:]]+' <<<"$segment"; then
      block "force-push is forbidden."
    fi
    if grep -Eq '[[:space:]:]main([[:space:]]|$)' <<<"$segment"; then
      block "pushing to main is forbidden; push a branch and open a PR."
    fi
  fi
done <<<"$segments"
exit 0
