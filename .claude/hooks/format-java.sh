#!/usr/bin/env bash
# PostToolUse hook for Edit|Write: formats an edited .java file with Spotless (palantir-java-format).
# Non-blocking by design: any failure exits 0 so a formatting problem never stops the agent.
set -uo pipefail

hook_input="$(cat)"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$hook_input")"
working_directory="$(jq -r '.cwd // empty' <<<"$hook_input")"

case "$file_path" in
  *.java) ;;
  *) exit 0 ;;
esac

# `cwd` follows Claude into worktrees, $CLAUDE_PROJECT_DIR does not.
if [ -n "$working_directory" ] && [ "${file_path:0:1}" != "/" ]; then
  file_path="$working_directory/$file_path"
fi
[ -f "$file_path" ] || exit 0

project_root="$(git -C "$(dirname "$file_path")" rev-parse --show-toplevel 2>/dev/null)" || exit 0
[ -x "$project_root/mvnw" ] || exit 0

# palantir-java-format breaks on JDK 27 (NoSuchFieldError in javac); use JDK 21 like CI when macOS has it.
if java_21_home="$(/usr/libexec/java_home -v 21 2>/dev/null)"; then
  export JAVA_HOME="$java_21_home"
fi

# spotlessFiles is a regex over absolute paths; quote the path so dots and brackets match literally.
escaped_path="$(printf '%s' "$file_path" | sed 's/[][\.*^$+?(){}|]/\\&/g')"
(cd "$project_root" && ./mvnw -B -ntp -q spotless:apply -DspotlessFiles="$escaped_path" >/dev/null 2>&1) || true
exit 0
