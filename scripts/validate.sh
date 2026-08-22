#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common.sh"

VERSION=$(cat "$ROOT_DIR/VERSION")
MANIFEST="$ROOT_DIR/manifest.yaml"
PACKAGED_SKILLS=$(mktemp)
AUTOMATIC_SKILLS=$(mktemp)
ROUTING_SKILLS=$(mktemp)
ROUTING_AUTOMATIC=$(mktemp)
trap 'rm -f "$PACKAGED_SKILLS" "$AUTOMATIC_SKILLS" "$ROUTING_SKILLS" "$ROUTING_AUTOMATIC"' EXIT

[[ -n "$VERSION" ]] || fail "VERSION is empty."
[[ -f "$MANIFEST" ]] || fail "manifest.yaml is missing."
grep -q "^version: $VERSION$" "$MANIFEST" || fail "Manifest version does not match VERSION."
grep -q '^global_policy: global-agents.md$' "$MANIFEST" || fail "Manifest global policy is invalid."
grep -q '^routing_policy: routing.yaml$' "$MANIFEST" || fail "Manifest routing policy is invalid."

for required in README.md LICENSE VERSION manifest.yaml routing.yaml global-agents.md skills.md; do
  [[ -f "$ROOT_DIR/$required" ]] || fail "Required root file is missing: $required"
done

for required in architecture.md orchestration.md installation.md customization.md evaluation.md contributing.md; do
  [[ -f "$ROOT_DIR/docs/$required" ]] || fail "Required documentation is missing: docs/$required"
done

manifest_skills "$MANIFEST" > "$PACKAGED_SKILLS"
manifest_list "$MANIFEST" automatic_skills > "$AUTOMATIC_SKILLS"
[[ -s "$PACKAGED_SKILLS" ]] || fail "Manifest contains no skills."
[[ -s "$AUTOMATIC_SKILLS" ]] || fail "Manifest contains no automatic skills."
line_in_file research-before-solution "$PACKAGED_SKILLS" || fail "research-before-solution must be installed."
line_in_file threat-modeling "$PACKAGED_SKILLS" || fail "threat-modeling must be packaged."
line_in_file operational-readiness "$PACKAGED_SKILLS" || fail "operational-readiness must be packaged."
line_in_file technical-communication "$PACKAGED_SKILLS" || fail "technical-communication must be packaged."
line_in_file requirements-hardening "$PACKAGED_SKILLS" || fail "requirements-hardening must be packaged."
line_in_file secure-oauth-oidc "$PACKAGED_SKILLS" || fail "secure-oauth-oidc must be packaged."

duplicate=$(LC_ALL=C sort "$PACKAGED_SKILLS" | uniq -d)
[[ -z "$duplicate" ]] || fail "Manifest contains duplicate skill: $duplicate"

manifest_count=$(wc -l < "$PACKAGED_SKILLS" | tr -d ' ')
automatic_count=$(wc -l < "$AUTOMATIC_SKILLS" | tr -d ' ')
directory_count=$(find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
[[ "$manifest_count" -eq 14 ]] || fail "Version $VERSION must package exactly 14 skills."
[[ "$automatic_count" -eq 3 ]] || fail "Version $VERSION must expose exactly 3 automatic skills."
[[ "$manifest_count" -eq "$directory_count" ]] || fail "Manifest lists $manifest_count skills, but skills/ contains $directory_count directories."

while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  line_in_file "$skill" "$PACKAGED_SKILLS" || fail "Automatic skill is not packaged: $skill"
done < "$AUTOMATIC_SKILLS"

grep -q '^default: none$' "$ROOT_DIR/routing.yaml" || fail "Routing default must be none."
grep -q '^maximum_active_working_skills: 1$' "$ROOT_DIR/routing.yaml" || fail "Routing must allow at most one active working skill."
grep -q '^automatic_handoffs: false$' "$ROOT_DIR/routing.yaml" || fail "Automatic handoffs must be disabled."
grep -q '^  skill: incident-control$' "$ROOT_DIR/routing.yaml" || fail "Routing must define incident-control supervisory context."
routing_skills "$ROOT_DIR/routing.yaml" > "$ROUTING_SKILLS"
routing_skills_with_activation "$ROOT_DIR/routing.yaml" automatic > "$ROUTING_AUTOMATIC"
cmp -s <(LC_ALL=C sort "$PACKAGED_SKILLS") <(LC_ALL=C sort "$ROUTING_SKILLS") || fail "Routing skill inventory does not match the manifest."
cmp -s <(LC_ALL=C sort "$AUTOMATIC_SKILLS") <(LC_ALL=C sort "$ROUTING_AUTOMATIC") || fail "Routing automatic skills do not match the manifest profile."

while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  case "$skill" in
    *[!a-z0-9-]*) fail "Invalid skill name in manifest: $skill" ;;
  esac
  directory="$ROOT_DIR/skills/$skill"
  skill_file="$directory/SKILL.md"

  [[ -f "$skill_file" ]] || fail "Missing SKILL.md: $skill"
  grep -q '^---$' "$skill_file" || fail "Missing YAML delimiters: $skill"
  grep -q "^name: $skill$" "$skill_file" || fail "Frontmatter name mismatch: $skill"
  grep -q '^description:' "$skill_file" || fail "Missing description: $skill"
  [[ ! -e "$directory/agents" ]] || fail "Provider-specific agents metadata is not allowed in the portable core: $skill"

  line_count=$(wc -l < "$skill_file" | tr -d ' ')
  [[ "$line_count" -le 500 ]] || fail "SKILL.md exceeds 500 lines: $skill"

  if grep -qE 'TODO|\[TODO' "$skill_file"; then
    fail "Unresolved placeholder in skill: $skill"
  fi

  for forbidden in README.md CHANGELOG.md VERSION LICENSE; do
    [[ ! -e "$directory/$forbidden" ]] || fail "Extraneous per-skill file: $skill/$forbidden"
  done

  if [[ -d "$directory/references" ]]; then
    find "$directory/references" -type f -name '*.md' | grep -q . || fail "Empty references directory: $skill"
    while IFS= read -r link; do
      relative=${link#](}
      relative=${relative%)}
      [[ -f "$directory/$relative" ]] || fail "Broken skill reference: $skill/$relative"
    done < <(grep -oE '\]\(references/[^)#]+\.md\)' "$skill_file" || true)
  fi

  [[ -f "$ROOT_DIR/evals/skills/$skill.yaml" ]] || fail "Missing skill contract cases: $skill"
done < "$PACKAGED_SKILLS"

if grep -RInE 'openai|codex|claude|gemini' "$ROOT_DIR/skills" "$ROOT_DIR/global-agents.md" "$ROOT_DIR/routing.yaml" >/dev/null 2>&1; then
  fail "Portable skill core contains provider-specific metadata or instructions."
fi

[[ ! -e "$ROOT_DIR/skills/implement-and-prove" ]] || fail "Routine implementation must not be packaged as an automatic skill."
[[ ! -e "$ROOT_DIR/skills/architecture-evolution" ]] || fail "Structural analysis must remain a conditional research reference."
[[ -f "$ROOT_DIR/skills/research-before-solution/references/architecture-model.md" ]] || fail "Research is missing the structural analysis reference."

while IFS= read -r directory; do
  skill=${directory##*/}
  line_in_file "$skill" "$PACKAGED_SKILLS" || fail "Unmanifested skill directory: $skill"
done < <(find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)

for required in routing.yaml handoffs.yaml restraint.yaml; do
  [[ -f "$ROOT_DIR/evals/cross-skill/$required" ]] || fail "Missing cross-skill evaluation: $required"
done

grep -q 'expected: \[\]' "$ROOT_DIR/evals/cross-skill/routing.yaml" || fail "Routing evaluations must include no-skill cases."

for required in complex-change.yaml production-incident.yaml security-design.yaml service-launch.yaml trivial-change.yaml; do
  [[ -f "$ROOT_DIR/evals/end-to-end/$required" ]] || fail "Missing end-to-end evaluation: $required"
done

for required in README.md dimensions.yaml scenarios.yaml; do
  [[ -f "$ROOT_DIR/benchmark/$required" ]] || fail "Missing benchmark file: $required"
done

if grep -RInE 'TODO|\[TODO' "$ROOT_DIR" --exclude=validate.sh --exclude-dir=.git >/dev/null 2>&1; then
  fail "Repository contains unresolved placeholders."
fi

if grep -RIn '—\|–' "$ROOT_DIR" --exclude=validate.sh --exclude-dir=.git >/dev/null 2>&1; then
  fail "Repository contains long dash punctuation."
fi

for script in "$ROOT_DIR/scripts"/*.sh; do
  bash -n "$script"
done

info "Validated Engineering OS $VERSION with $manifest_count skills."
