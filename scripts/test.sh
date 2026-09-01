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

# Default installation exposes every packaged skill for agent discovery.
TEST_HOME="$TMP_ROOT/default"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 18 ]] || fail "Default installation installed $actual skills instead of 18."
[[ ! -e "$TEST_HOME/.agents/lang" ]] || fail "Keeping AGENTS.md installed language defaults."
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Default installation omitted manifest skill: $skill"
done < <(manifest_skills "$ROOT_DIR/manifest.yaml")
for relative in \
  architecture-assessment/references/assessment-evidence.md \
  causal-debugging/references/performance-investigation.md \
  frontend-design/references/accessibility.md \
  research-before-solution/references/capacity-estimation.md \
  research-before-solution/references/architecture-opportunity-review.md \
  research-before-solution/references/public-api-contracts.md \
  research-before-solution/references/observability-design.md \
  research-before-solution/references/transactions-and-consistency.md \
  operational-readiness/references/observability-evidence.md \
  requirements-hardening/references/domain-language.md \
  security-testing/references/testing-method.md \
  technical-writing/references/architecture-diagrams.md \
  testing/references/behavior-testing-examples.md \
  testing/references/mutation-test-design.md \
  testing/references/special-test-evidence.md \
  testing/references/test-quality-properties.md; do
  [[ -f "$TEST_HOME/.agents/skills/$relative" ]] || fail "Default installation omitted reference: $relative"
  cmp -s "$ROOT_DIR/skills/$relative" "$TEST_HOME/.agents/skills/$relative" || fail "Installed reference differs from source: $relative"
done
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
remaining=$(installed_count "$TEST_HOME")
[[ "$remaining" -eq 0 ]] || fail "Default uninstall left managed skills behind."

# The automatic profile is an explicit narrow installation option.
TEST_HOME="$TMP_ROOT/automatic"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile automatic --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 4 ]] || fail "Automatic profile installed $actual skills instead of 4."
for skill in research-before-solution causal-debugging incident-control testing; do
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Automatic profile omitted: $skill"
done
for skill in execution-planning adversarial-review acceptance-review story-splitting reduce-system-complexity requirements-hardening secure-oauth-oidc knowledge-promotion technical-writing frontend-design threat-modeling operational-readiness architecture-assessment security-testing; do
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Automatic profile exposed request-only skill: $skill"
done
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
remaining=$(installed_count "$TEST_HOME")
[[ "$remaining" -eq 0 ]] || fail "Uninstall left managed skills behind."

# Full installation exposes all eighteen packaged capabilities.
TEST_HOME="$TMP_ROOT/full"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile full --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 18 ]] || fail "Full profile installed $actual skills instead of 18."
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
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 18 ]] || fail "Update did not preserve the full profile."

# Deliberately shrinking a profile reconciles request-only skills.
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile automatic --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 4 ]] || fail "Profile change did not reconcile the full profile to automatic."
for skill in execution-planning adversarial-review acceptance-review story-splitting reduce-system-complexity requirements-hardening secure-oauth-oidc knowledge-promotion technical-writing frontend-design threat-modeling operational-readiness architecture-assessment security-testing; do
  [[ ! -e "$TEST_HOME/.agents/skills/$skill" ]] || fail "Profile change left request-only skill installed: $skill"
done

# Custom installation exposes exactly the requested subset.
TEST_HOME="$TMP_ROOT/custom"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --skills acceptance-review,requirements-hardening,secure-oauth-oidc --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 3 ]] || fail "Custom profile installed $actual skills instead of 3."
for skill in acceptance-review requirements-hardening secure-oauth-oidc; do
  [[ -f "$TEST_HOME/.agents/skills/$skill/SKILL.md" ]] || fail "Custom profile omitted: $skill"
done
[[ ! -e "$TEST_HOME/.agents/skills/causal-debugging" ]] || fail "Custom profile installed an unrequested skill."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
actual=$(installed_count "$TEST_HOME")
[[ "$actual" -eq 3 ]] || fail "Update did not preserve the custom skill selection."

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
[[ -d "$ROOT_DIR/lang" ]] || fail "Packaged language defaults are missing."
while IFS= read -r source; do
  relative=${source#"$ROOT_DIR/lang/"}
  target="$TEST_HOME/.agents/lang/$relative"
  [[ -f "$target" ]] || fail "Policy replacement omitted language default: $relative"
  cmp -s "$source" "$target" || fail "Installed language default differs from source: $relative"
done < <(find "$ROOT_DIR/lang" -type f | LC_ALL=C sort)
grep -q 'TypeScript: `lang/typescript.md`' "$TEST_HOME/.agents/AGENTS.md" || fail "Installed policy does not route TypeScript defaults through lang/."

# A custom policy target receives language defaults beside AGENTS.md.
TEST_HOME="$TMP_ROOT/custom-policy-target"
mkdir -p "$TEST_HOME"
CUSTOM_AGENTS_TARGET="$TEST_HOME/policy/AGENTS.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile none --agents replace --agents-target "$CUSTOM_AGENTS_TARGET" >/dev/null
cmp -s "$ROOT_DIR/global-agents.md" "$CUSTOM_AGENTS_TARGET" || fail "Custom policy target did not receive AGENTS.md."
cmp -s "$ROOT_DIR/lang/typescript.md" "$TEST_HOME/policy/lang/typescript.md" || fail "Custom policy target did not receive sibling language defaults."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents restore --agents-target "$CUSTOM_AGENTS_TARGET" >/dev/null
[[ ! -e "$CUSTOM_AGENTS_TARGET" ]] || fail "Custom policy uninstall left Engineering OS-created AGENTS.md."
[[ ! -e "$TEST_HOME/policy/lang" ]] || fail "Custom policy uninstall left Engineering OS-created language defaults."

# A retry completes an interrupted language-directory commit.
TEST_HOME="$TMP_ROOT/language-install-retry"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile none --agents replace >/dev/null
mv "$TEST_HOME/.agents/.engineering-os/lang.sha256" "$TEST_HOME/.agents/.engineering-os/lang.pending.sha256"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
[[ ! -e "$TEST_HOME/.agents/.engineering-os/lang.pending.sha256" ]] || fail "Language retry left pending installation state."
cmp -s "$ROOT_DIR/lang/typescript.md" "$TEST_HOME/.agents/lang/typescript.md" || fail "Language retry did not restore packaged content."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents restore >/dev/null

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
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
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

# Corrupt language state fails before uninstall changes managed targets.
TEST_HOME="$TMP_ROOT/language-uninstall-preflight"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile none --agents replace >/dev/null
awk '$1 != "typescript.md"' "$TEST_HOME/.agents/.engineering-os/lang.sha256" > "$TEST_HOME/.agents/.engineering-os/lang.sha256.invalid"
mv "$TEST_HOME/.agents/.engineering-os/lang.sha256.invalid" "$TEST_HOME/.agents/.engineering-os/lang.sha256"
if HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents restore >/dev/null 2>&1; then
  fail "Uninstall accepted incomplete language hash state."
fi
[[ -f "$TEST_HOME/.agents/AGENTS.md" ]] || fail "Failed language preflight removed AGENTS.md."
[[ -f "$TEST_HOME/.agents/lang/typescript.md" ]] || fail "Failed language preflight removed a managed language file."

# A modified managed skill blocks update before replacement.
TEST_HOME="$TMP_ROOT/modified-skill"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
printf '\nuser modification\n' >> "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md"
printf '\nsecond user modification\n' >> "$TEST_HOME/.agents/skills/causal-debugging/SKILL.md"
if HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null 2>&1; then
  fail "Update replaced a modified managed skill."
fi
grep -q 'user modification' "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md" || fail "Modified skill content was lost."
grep -q 'second user modification' "$TEST_HOME/.agents/skills/causal-debugging/SKILL.md" || fail "Second modified skill content was lost."
[[ ! -e "$TEST_HOME/.agents/.engineering-os/backups/modified-skills" ]] || fail "Blocked update created modified-skill backups."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --replace-modified --agents keep --dry-run >/dev/null
grep -q 'user modification' "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md" || fail "Dry-run replacement changed research content."
grep -q 'second user modification' "$TEST_HOME/.agents/skills/causal-debugging/SKILL.md" || fail "Dry-run replacement changed debugging content."
[[ ! -e "$TEST_HOME/.agents/.engineering-os/backups/modified-skills" ]] || fail "Dry-run replacement created modified-skill backups."

# Explicit replacement preserves every changed package, installs canonical content, and refreshes hashes.
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --replace-modified --agents keep >/dev/null
cmp -s "$ROOT_DIR/skills/research-before-solution/SKILL.md" "$TEST_HOME/.agents/skills/research-before-solution/SKILL.md" || fail "Explicit replacement did not install canonical research content."
cmp -s "$ROOT_DIR/skills/causal-debugging/SKILL.md" "$TEST_HOME/.agents/skills/causal-debugging/SKILL.md" || fail "Explicit replacement did not install canonical debugging content."
modified_backup_root="$TEST_HOME/.agents/.engineering-os/backups/modified-skills"
actual=$(find "$modified_backup_root" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
[[ "$actual" -eq 2 ]] || fail "Explicit replacement created $actual modified-skill backups instead of 2."
grep -R -q '^user modification$' "$modified_backup_root" || fail "Research modification was not preserved in a backup."
grep -R -q '^second user modification$' "$modified_backup_root" || fail "Debugging modification was not preserved in a backup."
while read -r skill recorded_hash; do
  current_hash=$(dir_sha256 "$TEST_HOME/.agents/skills/$skill")
  [[ "$current_hash" == "$recorded_hash" ]] || fail "Explicit replacement did not refresh the managed hash for: $skill"
done < "$TEST_HOME/.agents/.engineering-os/skills.sha256"

# Explicit profile reduction preserves a changed managed skill before removal.
printf '\nremoved-skill-local-change\n' >> "$TEST_HOME/.agents/skills/operational-readiness/SKILL.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --profile automatic --replace-modified --agents keep >/dev/null
[[ ! -e "$TEST_HOME/.agents/skills/operational-readiness" ]] || fail "Explicit profile reduction left a deselected managed skill installed."
grep -R -q '^removed-skill-local-change$' "$modified_backup_root" || fail "Deselected modified skill was not preserved in a backup."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
[[ -d "$modified_backup_root" ]] || fail "Uninstall removed modified-skill backups."
grep -R -q '^user modification$' "$modified_backup_root" || fail "Uninstall removed the research backup."
grep -R -q '^second user modification$' "$modified_backup_root" || fail "Uninstall removed the debugging backup."
grep -R -q '^removed-skill-local-change$' "$modified_backup_root" || fail "Uninstall removed the deselected-skill backup."

# Original AGENTS.md is restored.
TEST_HOME="$TMP_ROOT/restore-agents"
mkdir -p "$TEST_HOME/.agents/lang"
printf 'original policy\n' > "$TEST_HOME/.agents/AGENTS.md"
printf 'original TypeScript defaults\n' > "$TEST_HOME/.agents/lang/typescript.md"
printf 'unrelated language defaults\n' > "$TEST_HOME/.agents/lang/user-owned.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
cmp -s "$ROOT_DIR/lang/typescript.md" "$TEST_HOME/.agents/lang/typescript.md" || fail "Policy replacement did not install TypeScript defaults."
grep -q '^unrelated language defaults$' "$TEST_HOME/.agents/lang/user-owned.md" || fail "Policy replacement changed an unrelated language file."
printf '\nuser language edit before restore\n' >> "$TEST_HOME/.agents/lang/typescript.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents restore >/dev/null
grep -q '^original policy$' "$TEST_HOME/.agents/AGENTS.md" || fail "Original AGENTS.md was not restored."
grep -q '^original TypeScript defaults$' "$TEST_HOME/.agents/lang/typescript.md" || fail "Original TypeScript defaults were not restored."
grep -q '^unrelated language defaults$' "$TEST_HOME/.agents/lang/user-owned.md" || fail "Uninstall removed an unrelated language file."
grep -R -q '^user language edit before restore$' "$TEST_HOME/.agents/.engineering-os/backups/modified-lang" || fail "Restore did not preserve modified language defaults in a backup."
for relative in go.md python.md csharp.md rust.md; do
  [[ ! -e "$TEST_HOME/.agents/lang/$relative" ]] || fail "Uninstall left Engineering OS-created language defaults: $relative"
done

# Modified installed AGENTS.md is preserved by default.
TEST_HOME="$TMP_ROOT/modified-agents"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
printf '\nuser policy edit\n' >> "$TEST_HOME/.agents/AGENTS.md"
printf '\nuser language edit\n' >> "$TEST_HOME/.agents/lang/typescript.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents keep >/dev/null
grep -q 'user policy edit' "$TEST_HOME/.agents/AGENTS.md" || fail "Keeping AGENTS.md replaced a modified policy."
grep -q 'user language edit' "$TEST_HOME/.agents/lang/typescript.md" || fail "Keeping AGENTS.md replaced modified language defaults."
HOME="$TEST_HOME" "$ROOT_DIR/scripts/uninstall.sh" --agents keep >/dev/null
grep -q 'user policy edit' "$TEST_HOME/.agents/AGENTS.md" || fail "Modified AGENTS.md was not preserved."
grep -q 'user language edit' "$TEST_HOME/.agents/lang/typescript.md" || fail "Modified language defaults were not preserved."
[[ ! -e "$TEST_HOME/.agents/lang/go.md" ]] || fail "Uninstall left an unchanged managed language file."

# Explicit replacement overwrites a modified managed AGENTS.md.
TEST_HOME="$TMP_ROOT/replace-modified-agents"
mkdir -p "$TEST_HOME"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
printf '\nuser policy edit\n' >> "$TEST_HOME/.agents/AGENTS.md"
printf '\nuser language edit\n' >> "$TEST_HOME/.agents/lang/typescript.md"
HOME="$TEST_HOME" "$ROOT_DIR/scripts/install.sh" --agents replace >/dev/null
cmp -s "$ROOT_DIR/global-agents.md" "$TEST_HOME/.agents/AGENTS.md" || fail "Explicit replacement did not overwrite AGENTS.md."
cmp -s "$ROOT_DIR/lang/typescript.md" "$TEST_HOME/.agents/lang/typescript.md" || fail "Explicit replacement did not overwrite modified language defaults."
grep -R -q '^user language edit$' "$TEST_HOME/.agents/.engineering-os/backups/modified-lang" || fail "Explicit replacement did not preserve modified language defaults in a backup."

info "Installer profile and lifecycle smoke checks passed."
