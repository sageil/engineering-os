#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common.sh"

AGENTS_MODE=""
DRY_RUN=0
PROFILE=""
CUSTOM_SKILLS=""
SELECTION_SET=0
SKILLS_TARGET="${HOME}/.agents/skills"
AGENTS_TARGET="${HOME}/.agents/AGENTS.md"
GLOBAL_POLICY="$ROOT_DIR/global-agents.md"
MANIFEST="$ROOT_DIR/manifest.yaml"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --profile automatic|full|none
                         Select the exposed skill profile.
                         New installations default to automatic.
  --skills NAME,...      Install an exact comma-separated skill subset.
  --agents keep|replace  Keep or replace the global AGENTS.md.
  --skills-target PATH   Skills directory (default: ~/.agents/skills).
  --agents-target PATH   AGENTS.md path (default: ~/.agents/AGENTS.md).
  --dry-run              Show operations without changing files.
  -h, --help             Show this help.
USAGE
}

while (($#)); do
  case "$1" in
    --profile)
      [[ $# -ge 2 ]] || fail "--profile requires a value"
      [[ $SELECTION_SET -eq 0 ]] || fail "Use only one of --profile or --skills"
      PROFILE=$2
      SELECTION_SET=1
      shift 2
      ;;
    --skills)
      [[ $# -ge 2 ]] || fail "--skills requires a value"
      [[ $SELECTION_SET -eq 0 ]] || fail "Use only one of --profile or --skills"
      PROFILE=custom
      CUSTOM_SKILLS=$2
      SELECTION_SET=1
      shift 2
      ;;
    --agents)
      [[ $# -ge 2 ]] || fail "--agents requires a value"
      AGENTS_MODE=$2
      shift 2
      ;;
    --skills-target)
      [[ $# -ge 2 ]] || fail "--skills-target requires a path"
      SKILLS_TARGET=$2
      shift 2
      ;;
    --agents-target)
      [[ $# -ge 2 ]] || fail "--agents-target requires a path"
      AGENTS_TARGET=$2
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

[[ -z "$AGENTS_MODE" || "$AGENTS_MODE" == keep || "$AGENTS_MODE" == replace ]] || fail "--agents must be keep or replace"
[[ -z "$PROFILE" || "$PROFILE" == automatic || "$PROFILE" == full || "$PROFILE" == none || "$PROFILE" == custom ]] || fail "--profile must be automatic, full, or none"
[[ -n "$SKILLS_TARGET" && "$SKILLS_TARGET" != / ]] || fail "Refusing broad skills target: $SKILLS_TARGET"
[[ -n "$AGENTS_TARGET" && "$AGENTS_TARGET" != / ]] || fail "Refusing broad AGENTS.md target: $AGENTS_TARGET"
[[ -f "$GLOBAL_POLICY" ]] || fail "Packaged global policy not found: $GLOBAL_POLICY"
[[ -f "$MANIFEST" ]] || fail "Package manifest not found: $MANIFEST"

if [[ -z "$AGENTS_MODE" ]]; then
  if [[ -t 0 ]]; then
    printf '\nEngineering OS installs skills into:\n  %s\n\n' "$SKILLS_TARGET"
    printf 'The optional global policy target is:\n  %s\n\n' "$AGENTS_TARGET"
    cat <<MENU
Choose an AGENTS.md option:
  1. Keep the existing file unchanged (default)
  2. Back up and replace/install Engineering OS AGENTS.md
  3. Show the proposed AGENTS.md
  4. Cancel
MENU
    while true; do
      read -r -p '> ' choice || choice=1
      case "${choice:-1}" in
        1) AGENTS_MODE=keep; break ;;
        2) AGENTS_MODE=replace; break ;;
        3) cat "$GLOBAL_POLICY" ;;
        4) info "Installation cancelled."; exit 0 ;;
        *) info "Choose 1, 2, 3, or 4." ;;
      esac
    done
  else
    AGENTS_MODE=keep
  fi
fi

AGENTS_ROOT=$(dirname "$AGENTS_TARGET")
STATE_DIR="$AGENTS_ROOT/.engineering-os"
STATE_FILE="$STATE_DIR/install-state.env"
SKILLS_STATE="$STATE_DIR/skills.list"
SKILLS_HASHES="$STATE_DIR/skills.sha256"
ORIGINAL_SKILLS="$STATE_DIR/original-skills.env"
SKILLS_BACKUPS="$STATE_DIR/backups/skills"
AGENTS_BACKUPS="$STATE_DIR/backups/agents"

ALL_SKILLS=$(mktemp)
AUTOMATIC_SKILLS=$(mktemp)
PACKAGED_SKILLS=$(mktemp)
OLD_SKILLS=$(mktemp)
SOURCE_SKILLS=$(mktemp)
HASH_SKILLS=$(mktemp)
trap 'rm -f "$ALL_SKILLS" "$AUTOMATIC_SKILLS" "$PACKAGED_SKILLS" "$OLD_SKILLS" "$SOURCE_SKILLS" "$HASH_SKILLS"' EXIT
manifest_skills "$MANIFEST" > "$ALL_SKILLS"
manifest_list "$MANIFEST" automatic_skills > "$AUTOMATIC_SKILLS"
[[ -s "$ALL_SKILLS" ]] || fail "Manifest contains no skills."
[[ -s "$AUTOMATIC_SKILLS" ]] || fail "Manifest contains no automatic skills."
find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; > "$SOURCE_SKILLS"
cmp -s <(LC_ALL=C sort "$ALL_SKILLS") <(LC_ALL=C sort "$SOURCE_SKILLS") || fail "Packaged skill directories do not match the manifest."

if [[ -f "$STATE_FILE" ]]; then
  [[ -f "$SKILLS_STATE" ]] || fail "Installation state is missing skills.list."
  [[ -f "$SKILLS_HASHES" ]] || fail "Installation state is missing skills.sha256."
  cp "$SKILLS_STATE" "$OLD_SKILLS"
  duplicate=$(LC_ALL=C sort "$OLD_SKILLS" | uniq -d)
  [[ -z "$duplicate" ]] || fail "Installation state contains a duplicate skill: $duplicate"
  awk 'NF { if (NF != 2 || $1 !~ /^[a-z0-9-]+$/ || $2 !~ /^[0-9a-f]+$/ || length($2) != 64) exit 1; print $1 }' "$SKILLS_HASHES" > "$HASH_SKILLS" || fail "Installation state contains an invalid skill hash record."
  cmp -s <(LC_ALL=C sort "$OLD_SKILLS") <(LC_ALL=C sort "$HASH_SKILLS") || fail "Installed skill and hash inventories do not match."

  while IFS= read -r skill || [[ -n "$skill" ]]; do
    [[ -n "$skill" ]] || continue
    case "$skill" in
      *[!a-z0-9-]*) fail "Installation state contains an invalid skill name: $skill" ;;
    esac
  done < "$OLD_SKILLS"

  if [[ -f "$ORIGINAL_SKILLS" ]]; then
    while IFS='=' read -r skill backup || [[ -n "$skill" ]]; do
      [[ -n "$skill" ]] || continue
      line_in_file "$skill" "$OLD_SKILLS" || fail "Skill backup mapping is not managed: $skill"
      case "$backup" in
        "$SKILLS_BACKUPS"/*) ;;
        *) fail "Skill backup is outside the managed backup root: $backup" ;;
      esac
      [[ -d "$backup" ]] || fail "Pre-installation skill backup is missing: $backup"
    done < "$ORIGINAL_SKILLS"
  fi
elif [[ -e "$SKILLS_STATE" || -e "$SKILLS_HASHES" || -e "$ORIGINAL_SKILLS" ]]; then
  fail "Partial installation state exists without install-state.env. Remove or recover the state directory before installing."
fi

STORED_PROFILE=$(state_get "$STATE_FILE" PROFILE 2>/dev/null || true)

if [[ -z "$PROFILE" ]]; then
  if [[ -f "$STATE_FILE" ]]; then
    case "$STORED_PROFILE" in
      automatic|full|none|custom) PROFILE=$STORED_PROFILE ;;
      *) fail "Installation state contains an unsupported profile: ${STORED_PROFILE:-missing}" ;;
    esac
  else
    PROFILE=automatic
  fi
fi

case "$PROFILE" in
  automatic)
    cp "$AUTOMATIC_SKILLS" "$PACKAGED_SKILLS"
    ;;
  full)
    cp "$ALL_SKILLS" "$PACKAGED_SKILLS"
    ;;
  none)
    : > "$PACKAGED_SKILLS"
    ;;
  custom)
    if [[ -n "$CUSTOM_SKILLS" ]]; then
      printf '%s\n' "$CUSTOM_SKILLS" | tr ',' '\n' | awk '{ gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length) print }' > "$PACKAGED_SKILLS"
    elif [[ -s "$OLD_SKILLS" ]]; then
      while IFS= read -r skill || [[ -n "$skill" ]]; do
        line_in_file "$skill" "$ALL_SKILLS" && printf '%s\n' "$skill"
      done < "$OLD_SKILLS" > "$PACKAGED_SKILLS"
    else
      fail "Custom profile requires --skills NAME,..."
    fi
    [[ -s "$PACKAGED_SKILLS" ]] || fail "Custom skill selection is empty."
    ;;
  *) fail "Unsupported profile: $PROFILE" ;;
esac

if [[ -n "$(LC_ALL=C sort "$ALL_SKILLS" | uniq -d)" ]]; then
  fail "Manifest contains duplicate skill names."
fi

if [[ -n "$(LC_ALL=C sort "$PACKAGED_SKILLS" | uniq -d)" ]]; then
  fail "Selected skill list contains duplicate names."
fi

while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  line_in_file "$skill" "$ALL_SKILLS" || fail "Selected skill is not packaged: $skill"
done < "$PACKAGED_SKILLS"

while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  case "$skill" in
    *[!a-z0-9-]*) fail "Invalid skill name in manifest: $skill" ;;
  esac
  source_dir="$ROOT_DIR/skills/$skill"
  [[ -d "$source_dir" && -f "$source_dir/SKILL.md" ]] || fail "Invalid packaged skill: $skill"
  grep -q "^name: $skill$" "$source_dir/SKILL.md" || fail "Skill name does not match manifest: $skill"
  grep -q '^description:' "$source_dir/SKILL.md" || fail "Skill description is missing: $skill"
  [[ ! -e "$source_dir/agents" ]] || fail "Provider-specific agents metadata is not allowed: $skill"
done < "$ALL_SKILLS"

# Complete preflight for every old managed target before changing anything.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  target_dir="$SKILLS_TARGET/$skill"
  installed_hash=$(awk -v s="$skill" '$1 == s { print $2; exit }' "$SKILLS_HASHES" 2>/dev/null || true)
  [[ -n "$installed_hash" ]] || fail "Installation state is missing a hash for managed skill: $skill"
  if [[ -d "$target_dir" ]]; then
    current_hash=$(dir_sha256 "$target_dir")
    [[ "$current_hash" == "$installed_hash" ]] || fail "Managed skill changed since installation: $target_dir. Preserve or remove it before updating."
  elif [[ -e "$target_dir" ]]; then
    fail "Managed skill target is not a directory: $target_dir"
  fi
done < "$OLD_SKILLS"

# Validate untracked targets that will become managed.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  target_dir="$SKILLS_TARGET/$skill"
  if line_in_file "$skill" "$OLD_SKILLS"; then
    continue
  fi
  if [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
    fail "Skill target exists but is not a directory: $target_dir"
  fi
  if [[ -n "$(state_get "$ORIGINAL_SKILLS" "$skill" 2>/dev/null || true)" ]]; then
    fail "Installation state already contains an untracked backup mapping for: $skill"
  fi
done < "$PACKAGED_SKILLS"

managed_agents_hash=$(state_get "$STATE_FILE" AGENTS_INSTALLED_SHA256 2>/dev/null || true)
existing_agents_action=$(state_get "$STATE_FILE" AGENTS_ACTION 2>/dev/null || true)
if [[ -f "$STATE_FILE" ]]; then
  [[ "$existing_agents_action" == keep || "$existing_agents_action" == replace ]] || fail "Installation state contains an unsupported AGENTS.md action: ${existing_agents_action:-missing}"
  if [[ "$existing_agents_action" == replace ]]; then
    original_agents_existed=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 2>/dev/null || true)
    original_agents_backup=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_BACKUP 2>/dev/null || true)
    [[ -n "$managed_agents_hash" ]] || fail "Installation state is missing the installed AGENTS.md hash."
    [[ "$original_agents_existed" == 0 || "$original_agents_existed" == 1 ]] || fail "Installation state contains an invalid AGENTS.md origin flag."
    if [[ "$original_agents_existed" == 1 ]]; then
      case "$original_agents_backup" in
        "$AGENTS_BACKUPS"/*) ;;
        *) fail "AGENTS.md backup is outside the managed backup root: $original_agents_backup" ;;
      esac
      [[ -f "$original_agents_backup" ]] || fail "Original AGENTS.md backup is missing: $original_agents_backup"
    fi
  fi
fi
if [[ "$AGENTS_MODE" == replace && -e "$AGENTS_TARGET" && ! -f "$AGENTS_TARGET" ]]; then
  fail "AGENTS.md target is not a regular file: $AGENTS_TARGET"
fi

if ((DRY_RUN)); then
  info "Would create directory: $SKILLS_TARGET"
  info "Would create directory: $STATE_DIR"
else
  mkdir -p "$SKILLS_TARGET" "$STATE_DIR"
fi

# Reconcile previously managed skills that are no longer selected or packaged.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  if line_in_file "$skill" "$PACKAGED_SKILLS"; then
    continue
  fi

  target_dir="$SKILLS_TARGET/$skill"
  original=$(state_get "$ORIGINAL_SKILLS" "$skill" 2>/dev/null || true)
  if [[ -n "$original" && -d "$original" ]]; then
    if ((DRY_RUN)); then
      info "Would restore pre-installation skill backup: $original -> $target_dir"
    else
      atomic_replace_dir "$original" "$target_dir"
      safe_remove_managed_dir "$original" "$SKILLS_BACKUPS"
      state_remove "$ORIGINAL_SKILLS" "$skill"
      info "Restored pre-installation skill: $skill"
    fi
  elif [[ -d "$target_dir" ]]; then
    if ((DRY_RUN)); then
      info "Would remove managed skill no longer selected: $target_dir"
    else
      safe_remove_managed_dir "$target_dir" "$SKILLS_TARGET"
      info "Removed managed skill no longer selected: $skill"
    fi
  fi
done < "$OLD_SKILLS"

# Back up untracked collisions and install canonical skill packages.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  source_dir="$ROOT_DIR/skills/$skill"
  target_dir="$SKILLS_TARGET/$skill"

  if ! line_in_file "$skill" "$OLD_SKILLS" && [[ -d "$target_dir" ]]; then
    backup="$SKILLS_BACKUPS/$skill.$(utc_stamp)"
    if ((DRY_RUN)); then
      info "Would back up existing skill: $target_dir -> $backup"
    else
      mkdir -p "$SKILLS_BACKUPS"
      cp -R "$target_dir" "$backup"
      state_set "$ORIGINAL_SKILLS" "$skill" "$backup"
    fi
  fi

  if ((DRY_RUN)); then
    info "Would install skill: $skill -> $target_dir"
  else
    atomic_replace_dir "$source_dir" "$target_dir"
  fi
done < "$PACKAGED_SKILLS"

skill_count=$(wc -l < "$PACKAGED_SKILLS" | tr -d ' ')
if ((DRY_RUN)); then
  info "Would record installation state for $skill_count skills."
else
  cp "$PACKAGED_SKILLS" "$SKILLS_STATE"
  : > "$SKILLS_HASHES"
  while IFS= read -r skill; do
    printf '%s %s\n' "$skill" "$(dir_sha256 "$SKILLS_TARGET/$skill")" >> "$SKILLS_HASHES"
  done < "$SKILLS_STATE"
  state_set "$STATE_FILE" VERSION "$(cat "$ROOT_DIR/VERSION")"
  state_set "$STATE_FILE" PROFILE "$PROFILE"
  state_set "$STATE_FILE" SKILLS_TARGET "$SKILLS_TARGET"
  state_set "$STATE_FILE" AGENTS_TARGET "$AGENTS_TARGET"
  state_set "$STATE_FILE" INSTALLED_AT "$(utc_stamp)"
fi

if [[ "$AGENTS_MODE" == replace ]]; then
  source_agents_hash=$(sha256_file "$GLOBAL_POLICY")
  if [[ -f "$AGENTS_TARGET" && -z "$managed_agents_hash" ]]; then
    backup="$AGENTS_BACKUPS/AGENTS.md.$(utc_stamp).backup"
    if ((DRY_RUN)); then
      info "Would back up existing AGENTS.md: $AGENTS_TARGET -> $backup"
    else
      mkdir -p "$AGENTS_BACKUPS"
      cp -p "$AGENTS_TARGET" "$backup"
      chmod 0600 "$backup" 2>/dev/null || true
      state_set "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 1
      state_set "$STATE_FILE" AGENTS_ORIGINAL_BACKUP "$backup"
      state_set "$STATE_FILE" AGENTS_ORIGINAL_SHA256 "$(sha256_file "$AGENTS_TARGET")"
    fi
  elif [[ ! -e "$AGENTS_TARGET" && -z "$managed_agents_hash" ]]; then
    if ((!DRY_RUN)); then
      state_set "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 0
    fi
  fi

  if ((DRY_RUN)); then
    info "Would install global policy: $AGENTS_TARGET"
  else
    atomic_copy_file "$GLOBAL_POLICY" "$AGENTS_TARGET"
    state_set "$STATE_FILE" AGENTS_ACTION replace
    state_set "$STATE_FILE" AGENTS_INSTALLED_SHA256 "$source_agents_hash"
    info "Installed global policy: $AGENTS_TARGET"
  fi
else
  info "AGENTS.md left unchanged."
  if ((!DRY_RUN)) && [[ -z "$existing_agents_action" ]]; then
    state_set "$STATE_FILE" AGENTS_ACTION keep
  fi
fi

if ((DRY_RUN)); then
  info "Dry run complete. No target files changed."
else
  info "Installed Engineering OS $(cat "$ROOT_DIR/VERSION") with $skill_count skills (profile: $PROFILE)."
  info "Skills: $SKILLS_TARGET"
fi
