// Advisory hooks: formatting failures must never prevent the agent from working.
import { readFileSync, readdirSync, realpathSync } from "node:fs";
import { dirname, isAbsolute, relative, resolve, sep } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "../..");

// palantir-java-format breaks on JDK 27; use JDK 21 like CI when macOS has it.
function java21Environment() {
  const result = spawnSync("/usr/libexec/java_home", ["-v", "21"], { encoding: "utf8" });
  const javaHome = result.status === 0 ? result.stdout.trim() : "";
  return javaHome ? { ...process.env, JAVA_HOME: javaHome } : process.env;
}

function escapeRegex(text) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

try {
  const input = JSON.parse(readFileSync(0, "utf8"));
  if (process.argv[2] === "retro") {
    const count = readdirSync(resolve(root, ".claude/papercuts")).filter(
      (name) => name.endsWith(".md") && name !== "README.md",
    ).length;
    if (count >= 3) {
      process.stdout.write(
        JSON.stringify({
          systemMessage: `${count} papercuts waiting in .claude/papercuts — consider running the retro skill.`,
        }),
      );
    }
  } else if (process.argv[2] === "format" && input.tool_name === "apply_patch") {
    const patch = input.tool_input?.command;
    if (typeof patch !== "string") process.exit(0);
    const files = new Set();
    for (const line of patch.split("\n")) {
      const match = /^\*\*\* (?:Add File|Update File|Move to): (.+)$/.exec(line);
      if (!match) continue;
      const candidate = resolve(input.cwd || root, match[1]);
      if (!candidate.endsWith(".java")) continue;
      // Resolve symlinks too: never let a patch path format outside this checkout.
      let actual;
      try {
        actual = realpathSync(candidate);
      } catch {
        continue;
      }
      const local = relative(root, actual);
      if (local === ".." || local.startsWith(`..${sep}`) || isAbsolute(local)) continue;
      files.add(actual);
    }
    if (files.size > 0) {
      const pattern = [...files].map(escapeRegex).join("|");
      spawnSync("./mvnw", ["-B", "-ntp", "-q", "spotless:apply", `-DspotlessFiles=${pattern}`], {
        cwd: root,
        env: java21Environment(),
        stdio: "ignore",
        timeout: 85000,
      });
    }
  }
} catch {
  // Missing files, malformed payloads and unavailable tools are non-blocking.
}
