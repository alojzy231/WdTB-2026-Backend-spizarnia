#!/usr/bin/env bash
# Stop hook: when the papercuts inbox has 3+ entries, shows the user a one-line reminder to run `retro`.
# Non-blocking: it never prevents Claude from stopping.
set -uo pipefail

papercuts_directory="${CLAUDE_PROJECT_DIR:-.}/.claude/papercuts"
[ -d "$papercuts_directory" ] || exit 0

papercut_count="$(find "$papercuts_directory" -maxdepth 1 -type f -name '*.md' ! -name 'README.md' | wc -l | tr -d ' ')"

if [ "$papercut_count" -ge 3 ]; then
  printf '{"systemMessage": "%s papercuts waiting in .claude/papercuts — consider running the retro skill."}\n' "$papercut_count"
fi
exit 0
