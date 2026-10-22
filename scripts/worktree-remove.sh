#!/usr/bin/env bash
# Removes a lane's worktree, its port file and its local branch (if it was merged or deleted on GitHub).
# Usage: scripts/worktree-remove.sh <slug>
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 1
fi

slug="$1"
main_checkout="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
worktrees_directory="$main_checkout/.claude/worktrees"
worktree_path="$worktrees_directory/$slug"
ports_file="$worktrees_directory/$slug.ports.env"

if [ -f "$ports_file" ]; then
  port="$(sed -n 's/^PORT=//p' "$ports_file")"
  # Stop the lane's app if it is still running; never touch other ports.
  if [ -n "$port" ]; then
    /usr/sbin/lsof -ti "tcp:$port" | xargs kill 2>/dev/null || true
  fi
fi

if [ -e "$worktree_path" ]; then
  branch="$(git -C "$worktree_path" branch --show-current)"
  git -C "$main_checkout" worktree remove "$worktree_path"
  # -d (not -D): keeps the branch if it has unmerged commits.
  if [ -n "$branch" ]; then
    git -C "$main_checkout" branch -d "$branch" 2>/dev/null || echo "Kept branch $branch (not fully merged)." >&2
  fi
fi

rm -f "$ports_file"
echo "Removed $slug"
