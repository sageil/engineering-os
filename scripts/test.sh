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
for skill in execution-planning adversarial-review knowledge-promotion threat-modeling operational-readiness; do
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Automatic profile exposed request-only skill: $skill"
done
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
remaining=$(installed_count "$TEST_HOME")
[[ "$remaining" -eq 0 ]] || fail "Uninstall left managed skills behind."

# Full installation exposes all eight packaged capabilities.
TEST_HOME="$TMP_ROOT/full"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 8 ]] || fail "Full profile installed $actual skills instead of 8."
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Full profile omitted manifest skill: $skill"
done < <(manifest_skills "$ROOT_DIR/manifest.yaml")
[[ ! -e "$TEST_HOME/.agents/skills/architecture-evolution" ]] || fail "Full profile installed a removed skill."

# Full uninstall removes every managed skill and preserves unrelated skills.
TEST_HOME="$TMP_ROOT/full-uninstall"
mkdir -p "$TEST_HOME/.agents/skills/user-owned-skill"
printf 'user-owned skill\n' > "$TEST_HOME/.agents/skills/user-owned-skill/SKILL.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents keep >/dev/null
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Full uninstall left managed skill installed: $skill"
done < <(manifest_skills "$ROOT_DIR/manifest.yaml")
[[ -f "$TEST_HOME/.agents/skills/user-owned-skill/SKILL.md" ]] || fail "Full uninstall removed an unrelated skill."
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 1 ]] || fail "Full uninstall left an unexpected skill count: $actual"
[[ ! -e "$TEST_HOME/.agents/.engineering-os" ]] || fail "Full uninstall left installation state behind."

# Update preserves a recorded profile when no new selection is supplied.
TEST_HOME="$TMP_ROOT/full"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 8 ]] || fail "Update did not preserve the full profile."

# Deliberately shrinking a profile reconciles request-only skills.
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --profile automatic --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 3 ]] || fail "Profile change did not reconcile the full profile to automatic."
for skill in execution-planning adversarial-review knowledge-promotion threat-modeling operational-readiness; do
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Profile change left request-only skill installed: $skill"
done

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

# A removed or unknown skill cannot be selected.
TEST_HOME="$TMP_ROOT/invalid-selection"
mkdir -p "$TEST_HOME"
if HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --skills architecture-evolution --agents keep >/dev/null 2>&1; then
  fail "Installer accepted a skill absent from the current manifest."
fi
[[ ! -e "$TEST_HOME/.agents" ]] || fail "Rejected skill selection changed target files."

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

# A previously managed skill absent from the current manifest is removed during update.
TEST_HOME="$TMP_ROOT/removed-managed-skill"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
removed="$TEST_HOME/.agents/skills/architecture-evolution"
mkdir -p "$removed"
printf '%s\n' '---' 'name: architecture-evolution' 'description: removed' '---' > "$removed/SKILL.md"
printf '%s\n' architecture-evolution >> "$TEST_HOME/.agents/.engineering-os/skills.list"
printf '%s %s\n' architecture-evolution "$(dir_sha256 "$removed")" >> "$TEST_HOME/.agents/.engineering-os/skills.sha256"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/update.sh" --agents keep >/dev/null
[[ ! -e "$removed" ]] || fail "Update left a removed managed skill installed."

# Corrupt uninstall state fails before any managed skill is removed.
TEST_HOME="$TMP_ROOT/uninstall-preflight"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
awk '$1 != "causal-debugging"' "$TEST_HOME/.agents/.engineering-os/skills.sha256" > "$TEST_HOME/.agents/.engineering-os/skills.sha256.invalid"
mv "$TEST_HOME/.agents/.engineering-os/skills.sha256.invalid" "$TEST_HOME/.agents/.engineering-os/skills.sha256"
if HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null 2>&1; then
  fail "Uninstall accepted incomplete hash state."
fi
for skill in research-before-solution causal-debugging incident-control; do
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Failed uninstall partially removed managed skill: $skill"
done

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
