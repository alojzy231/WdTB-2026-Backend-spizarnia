#!/usr/bin/env bash
# Creates a worktree for one parallel lane:
#   - .claude/worktrees/<slug> on a new branch from origin/main
#   - a free port slot (PORT = 8080 + 10 * slot) written to .claude/worktrees/<slug>.ports.env,
#     outside the worktree so `git status` stays clean
# Each worktree gets its own H2 file database (./data/ is relative to the working directory).
#
# Rerunning it for an existing worktree resumes it: fast-forwards a clean worktree without own commits
# to origin/main.
#
# Usage: scripts/worktree-new.sh <slug> [branch]
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <slug> [branch]" >&2
  exit 1
fi

slug="$1"
branch="${2:-$slug}"

main_checkout="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
worktrees_directory="$main_checkout/.claude/worktrees"
worktree_path="$worktrees_directory/$slug"
ports_file="$worktrees_directory/$slug.ports.env"

if [ -e "$worktree_path" ]; then
  git -C "$main_checkout" fetch --quiet origin main
  if [ -z "$(git -C "$worktree_path" status --porcelain)" ] &&
    git -C "$worktree_path" merge-base --is-ancestor HEAD origin/main; then
    git -C "$worktree_path" merge --quiet --ff-only origin/main
  else
    echo "Kept the branch as is (own commits or changes); $(git -C "$worktree_path" rev-list --count HEAD..origin/main) commits behind origin/main." >&2
  fi
  echo "Resumed worktree: $worktree_path"
  [ -f "$ports_file" ] && cat "$ports_file"
  exit 0
fi

mkdir -p "$worktrees_directory"
git -C "$main_checkout" fetch --quiet origin main
git -C "$main_checkout" worktree add --quiet -b "$branch" "$worktree_path" origin/main

# Lowest slot not used by another worktree. Slot 0 (port 8080) is reserved for the main checkout.
slot=1
while grep -qsx "SLOT=$slot" "$worktrees_directory"/*.ports.env; do
  slot=$((slot + 1))
done
port=$((8080 + 10 * slot))

printf 'SLOT=%s\nPORT=%s\nBRANCH=%s\n' "$slot" "$port" "$branch" >"$ports_file"

echo "Worktree: $worktree_path"
echo "Branch:   $branch"
echo "Port:     $port  (run: SERVER_PORT=$port ./mvnw -q spring-boot:run)"
