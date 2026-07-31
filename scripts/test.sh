#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common.sh"

"$ROOT_DIR/scripts/validate.sh"

TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

installed_count() {
  local root=$1
  find "$root/.agents/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
}

# Default installation exposes only automatic capabilities.
TEST_HOME="$TMP_ROOT/automatic"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 3 ]] || fail "Automatic profile installed $actual skills instead of 3."
for skill in research-before-solution causal-debugging incident-control; do
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Automatic profile omitted: $skill"
done
[[ ! -e "$TEST_HOME/.agents/skills/execution-planning" ]] || fail "Automatic profile exposed request-only planning."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
remaining=$(installed_count "$TEST_HOME")
[[ "$remaining" -eq 0 ]] || fail "Uninstall left managed skills behind."

# Full installation exposes all packaged capabilities.
TEST_HOME="$TMP_ROOT/full"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 7 ]] || fail "Full profile installed $actual skills instead of 7."

# Full installation replaces the obsolete Engineering OS skill set.
TEST_HOME="$TMP_ROOT/full-with-obsolete-skills"
mkdir -p "$TEST_HOME/.agents/skills"
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  mkdir -p "$TEST_HOME/.agents/skills/$skill"
  printf 'obsolete skill\n' > "$TEST_HOME/.agents/skills/$skill/SKILL.md"
done < <(manifest_list "$ROOT_DIR/manifest.yaml" obsolete_skills)
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 7 ]] || fail "Full profile left an incorrect number of installed skills: $actual."
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Full profile left an obsolete skill installed: $skill"
done < <(manifest_list "$ROOT_DIR/manifest.yaml" obsolete_skills)

# Update preserves a recorded profile when no new selection is supplied.
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 7 ]] || fail "Update did not preserve the full profile."

# Deliberately shrinking a profile reconciles request-only skills.
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --profile automatic --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 3 ]] || fail "Profile change did not reconcile the full profile to automatic."
[[ ! -e "$TEST_HOME/.agents/skills/execution-planning" ]] || fail "Profile change left request-only planning installed."

# Custom installation exposes exactly the requested subset.
TEST_HOME="$TMP_ROOT/custom"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --skills research-before-solution,adversarial-review --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 2 ]] || fail "Custom profile installed $actual skills instead of 2."
[[ -f "$TEST_HOME/.agents/skills/adversarial-review/SKILL.md" ]] || fail "Custom profile omitted adversarial-review."
[[ ! -e "$TEST_HOME/.agents/skills/causal-debugging" ]] || fail "Custom profile installed an unrequested skill."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 2 ]] || fail "Update did not preserve the custom skill selection."

# None profile installs policy state without exposing skills.
TEST_HOME="$TMP_ROOT/none"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile none --agents replace >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 0 ]] || fail "None profile exposed $actual skills."
[[ -f "$TEST_HOME/.agents/AGENTS.md" ]] || fail "None profile did not install the requested global policy."

# Dry run creates no target state.
TEST_HOME="$TMP_ROOT/dry-run"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents replace --dry-run >/dev/null
[[ ! -e "$TEST_HOME/.agents" ]] || fail "Dry run changed target files."

# A pre-existing skill is restored after uninstall.
TEST_HOME="$TMP_ROOT/restore-skill"
mkdir -p "$TEST_HOME/.agents/skills/research-before-solution"
printf 'original skill\n' > "$TEST_HOME/.agents/skills/research-before-solution/original.txt"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
grep -q '^original skill$' "$TEST_HOME/.agents/skills/research-before-solution/original.txt" || fail "Pre-existing skill was not restored."

# An obsolete unchanged managed skill is removed during update.
TEST_HOME="$TMP_ROOT/obsolete"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
obsolete="$TEST_HOME/.agents/skills/engineering-investigation"
mkdir -p "$obsolete"
printf '%s\n' '---' 'name: engineering-investigation' 'description: legacy' '---' > "$obsolete/SKILL.md"
printf '%s\n' engineering-investigation >> "$TEST_HOME/.agents/.engineering-os/skills.list"
printf '%s %s\n' engineering-investigation "$(dir_sha256 "$obsolete")" >> "$TEST_HOME/.agents/.engineering-os/skills.sha256"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null
[[ ! -e "$obsolete" ]] || fail "Update left an obsolete managed skill installed."

# A modified managed skill blocks update before replacement.
TEST_HOME="$TMP_ROOT/modified-skill"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
printf '\nuser modification\n' >> "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md"
if HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null 2>&1; then
  fail "Update replaced a modified managed skill."
fi
grep -q 'user modification' "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md" || fail "Modified skill content was lost."

# Original AGENTS.md is restored.
TEST_HOME="$TMP_ROOT/restore-agents"
mkdir -p "$TEST_HOME/.agents"
printf 'original policy\n' > "$TEST_HOME/.agents/AGENTS.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents restore >/dev/null
grep -q '^original policy$' "$TEST_HOME/.agents/AGENTS.md" || fail "Original AGENTS.md was not restored."

# Modified installed AGENTS.md is preserved by default.
TEST_HOME="$TMP_ROOT/modified-agents"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
printf '\nuser policy edit\n' >> "$TEST_HOME/.agents/AGENTS.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
grep -q 'user policy edit' "$TEST_HOME/.agents/AGENTS.md" || fail "Modified AGENTS.md was not preserved."

# Explicit replacement overwrites a modified managed AGENTS.md.
TEST_HOME="$TMP_ROOT/replace-modified-agents"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
printf '\nuser policy edit\n' >> "$TEST_HOME/.agents/AGENTS.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
cmp -s "$ROOT_DIR/global-agents.md" "$TEST_HOME/.agents/AGENTS.md" || fail "Explicit replacement did not overwrite AGENTS.md."

info "Installer profile and lifecycle smoke checks passed."
