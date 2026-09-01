#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common.sh"

AGENTS_MODE=""
DRY_RUN=0
REPLACE_MODIFIED=0
PROFILE=""
CUSTOM_SKILLS=""
SELECTION_SET=0
SKILLS_TARGET="${HOME}/.agents/skills"
AGENTS_TARGET="${HOME}/.agents/AGENTS.md"
GLOBAL_POLICY="$ROOT_DIR/global-agents.md"
LANG_SOURCE="$ROOT_DIR/lang"
MANIFEST="$ROOT_DIR/manifest.yaml"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --profile automatic|full|none
                         Select the exposed skill profile.
                         New installations default to full.
  --skills NAME,...      Install an exact comma-separated skill subset.
  --agents keep|replace  Keep or replace the global AGENTS.md and language defaults.
  --skills-target PATH   Skills directory (default: ~/.agents/skills).
  --agents-target PATH   AGENTS.md path (default: ~/.agents/AGENTS.md).
  --replace-modified     Back up and replace changed managed skills.
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
    --replace-modified)
      REPLACE_MODIFIED=1
      shift
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
[[ -d "$LANG_SOURCE" ]] || fail "Packaged language defaults not found: $LANG_SOURCE"
[[ -z "$(find "$LANG_SOURCE" -type l -print -quit)" ]] || fail "Packaged language defaults must not contain symbolic links."
[[ -f "$MANIFEST" ]] || fail "Package manifest not found: $MANIFEST"

if [[ -z "$AGENTS_MODE" ]]; then
  if [[ -t 0 ]]; then
    printf '\nEngineering OS installs skills into:\n  %s\n\n' "$SKILLS_TARGET"
    printf 'The optional global policy target is:\n  %s\n\n' "$AGENTS_TARGET"
    cat <<MENU
Choose a global policy option:
  1. Keep the existing file unchanged (default)
  2. Back up and replace/install Engineering OS AGENTS.md and lang/**
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
LANG_TARGET="$AGENTS_ROOT/lang"
STATE_DIR="$AGENTS_ROOT/.engineering-os"
STATE_FILE="$STATE_DIR/install-state.env"
SKILLS_STATE="$STATE_DIR/skills.list"
SKILLS_HASHES="$STATE_DIR/skills.sha256"
ORIGINAL_SKILLS="$STATE_DIR/original-skills.env"
LANG_HASHES="$STATE_DIR/lang.sha256"
LANG_PENDING_HASHES="$STATE_DIR/lang.pending.sha256"
ORIGINAL_LANG="$STATE_DIR/original-lang.env"
SKILLS_BACKUPS="$STATE_DIR/backups/skills"
MODIFIED_SKILLS_BACKUPS="$STATE_DIR/backups/modified-skills"
AGENTS_BACKUPS="$STATE_DIR/backups/agents"
LANG_BACKUPS="$STATE_DIR/backups/lang"
MODIFIED_LANG_BACKUPS="$STATE_DIR/backups/modified-lang"

ALL_SKILLS=$(mktemp)
AUTOMATIC_SKILLS=$(mktemp)
PACKAGED_SKILLS=$(mktemp)
OLD_SKILLS=$(mktemp)
SOURCE_SKILLS=$(mktemp)
HASH_SKILLS=$(mktemp)
MODIFIED_SKILLS=$(mktemp)
PACKAGED_LANG=$(mktemp)
OLD_LANG=$(mktemp)
HASH_LANG=$(mktemp)
PENDING_LANG=$(mktemp)
MODIFIED_LANG=$(mktemp)
REMOVED_LANG_BACKUPS=$(mktemp)
STAGED_HASHES=""
STAGED_LANG_HASHES=""
STAGED_LANG=""
cleanup() {
  rm -f "$ALL_SKILLS" "$AUTOMATIC_SKILLS" "$PACKAGED_SKILLS" "$OLD_SKILLS" "$SOURCE_SKILLS" "$HASH_SKILLS" "$MODIFIED_SKILLS"
  rm -f "$PACKAGED_LANG" "$OLD_LANG" "$HASH_LANG" "$PENDING_LANG" "$MODIFIED_LANG" "$REMOVED_LANG_BACKUPS"
  if [[ -n "$STAGED_HASHES" ]]; then
    rm -f "$STAGED_HASHES"
  fi
  if [[ -n "$STAGED_LANG_HASHES" ]]; then
    rm -f "$STAGED_LANG_HASHES"
  fi
  if [[ -n "$STAGED_LANG" ]]; then
    rm -rf "$STAGED_LANG"
  fi
}
trap cleanup EXIT
manifest_skills "$MANIFEST" > "$ALL_SKILLS"
manifest_list "$MANIFEST" automatic_skills > "$AUTOMATIC_SKILLS"
[[ -s "$ALL_SKILLS" ]] || fail "Manifest contains no skills."
[[ -s "$AUTOMATIC_SKILLS" ]] || fail "Manifest contains no automatic skills."
find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; > "$SOURCE_SKILLS"
cmp -s <(LC_ALL=C sort "$ALL_SKILLS") <(LC_ALL=C sort "$SOURCE_SKILLS") || fail "Packaged skill directories do not match the manifest."
(
  cd "$LANG_SOURCE"
  find . -type f | sed 's#^\./##' | LC_ALL=C sort
) > "$PACKAGED_LANG"
[[ -s "$PACKAGED_LANG" ]] || fail "Packaged language defaults contain no files."
while IFS= read -r relative || [[ -n "$relative" ]]; do
  case "$relative" in
    ""|/*|../*|*/../*|*//*|*[!a-zA-Z0-9._/-]*) fail "Invalid packaged language path: $relative" ;;
    *.md) ;;
    *) fail "Packaged language default is not Markdown: $relative" ;;
  esac
done < "$PACKAGED_LANG"

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

if [[ -f "$LANG_HASHES" ]]; then
  recorded_lang_inventory_hash=$(state_get "$STATE_FILE" LANG_INVENTORY_SHA256 2>/dev/null || true)
  if [[ -s "$LANG_HASHES" ]]; then
    [[ -n "$recorded_lang_inventory_hash" ]] || fail "Installation state is missing the language inventory hash."
    [[ "$(sha256_file "$LANG_HASHES")" == "$recorded_lang_inventory_hash" ]] || fail "Installed language inventory does not match its recorded hash."
  elif [[ -n "$recorded_lang_inventory_hash" ]]; then
    fail "Installation state contains a hash for an empty language inventory."
  fi
  awk 'NF { if (NF != 2 || $1 !~ /^[a-zA-Z0-9._\/-]+$/ || $2 !~ /^[0-9a-f]+$/ || length($2) != 64) exit 1; print $1 }' "$LANG_HASHES" > "$HASH_LANG" || fail "Installation state contains an invalid language hash record."
  cp "$HASH_LANG" "$OLD_LANG"
  duplicate=$(LC_ALL=C sort "$OLD_LANG" | uniq -d)
  [[ -z "$duplicate" ]] || fail "Installation state contains a duplicate language path: $duplicate"
fi

if [[ -f "$LANG_PENDING_HASHES" ]]; then
  [[ "$AGENTS_MODE" == replace ]] || fail "Language installation is incomplete. Rerun with --agents replace."
  awk 'NF { if (NF != 2 || $1 !~ /^[a-zA-Z0-9._\/-]+$/ || $2 !~ /^[0-9a-f]+$/ || length($2) != 64) exit 1; print $1 }' "$LANG_PENDING_HASHES" > "$PENDING_LANG" || fail "Installation state contains an invalid pending language hash record."
  cmp -s "$PACKAGED_LANG" "$PENDING_LANG" || fail "Pending language inventory does not match the packaged language files."
  while read -r relative pending_hash; do
    [[ "$(sha256_file "$LANG_SOURCE/$relative")" == "$pending_hash" ]] || fail "Pending language content does not match the packaged file: $relative"
  done < "$LANG_PENDING_HASHES"
fi

if [[ -f "$ORIGINAL_LANG" ]]; then
  while IFS='=' read -r relative backup || [[ -n "$relative" ]]; do
    [[ -n "$relative" ]] || continue
    case "$relative" in
      ""|/*|../*|*/../*|*//*|*[!a-zA-Z0-9._/-]*) fail "Invalid language backup path: $relative" ;;
    esac
    case "$backup" in
      "$LANG_BACKUPS"/*) ;;
      *) fail "Language backup is outside the managed backup root: $backup" ;;
    esac
    [[ -f "$backup" ]] || fail "Pre-installation language backup is missing: $backup"
  done < "$ORIGINAL_LANG"
fi

STORED_PROFILE=$(state_get "$STATE_FILE" PROFILE 2>/dev/null || true)

if [[ -z "$PROFILE" ]]; then
  if [[ -f "$STATE_FILE" ]]; then
    case "$STORED_PROFILE" in
      automatic|full|none|custom) PROFILE=$STORED_PROFILE ;;
      *) fail "Installation state contains an unsupported profile: ${STORED_PROFILE:-missing}" ;;
    esac
  else
    PROFILE=full
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
: > "$MODIFIED_SKILLS"
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  target_dir="$SKILLS_TARGET/$skill"
  installed_hash=$(awk -v s="$skill" '$1 == s { print $2; exit }' "$SKILLS_HASHES" 2>/dev/null || true)
  [[ -n "$installed_hash" ]] || fail "Installation state is missing a hash for managed skill: $skill"
  if [[ -d "$target_dir" ]]; then
    current_hash=$(dir_sha256 "$target_dir")
    if [[ "$current_hash" != "$installed_hash" ]]; then
      printf '%s\n' "$skill" >> "$MODIFIED_SKILLS"
    fi
  elif [[ -e "$target_dir" ]]; then
    fail "Managed skill target is not a directory: $target_dir"
  fi
done < "$OLD_SKILLS"

if [[ -s "$MODIFIED_SKILLS" && $REPLACE_MODIFIED -eq 0 ]]; then
  while IFS= read -r skill; do
    info "Managed skill changed since installation: $SKILLS_TARGET/$skill"
  done < "$MODIFIED_SKILLS"
  fail "Preserve the changed skills or rerun with --replace-modified to back them up and install the packaged versions."
fi

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

: > "$MODIFIED_LANG"
if [[ "$AGENTS_MODE" == replace ]]; then
  if [[ -L "$LANG_TARGET" || ( -e "$LANG_TARGET" && ! -d "$LANG_TARGET" ) ]]; then
    fail "Language defaults target is not a regular directory: $LANG_TARGET"
  fi

  while IFS= read -r relative || [[ -n "$relative" ]]; do
    [[ -n "$relative" ]] || continue
    target="$LANG_TARGET/$relative"
    installed_hash=$(awk -v p="$relative" '$1 == p { print $2; exit }' "$LANG_HASHES" 2>/dev/null || true)
    [[ -n "$installed_hash" ]] || fail "Installation state is missing a hash for managed language file: $relative"
    if [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
      fail "Managed language target is not a regular file: $target"
    fi
    if [[ -f "$target" && "$(sha256_file "$target")" != "$installed_hash" ]]; then
      printf '%s\n' "$relative" >> "$MODIFIED_LANG"
    fi
  done < "$OLD_LANG"

  while IFS= read -r relative || [[ -n "$relative" ]]; do
    [[ -n "$relative" ]] || continue
    target="$LANG_TARGET/$relative"
    if [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
      fail "Language target exists but is not a regular file: $target"
    fi
  done < "$PACKAGED_LANG"
fi

if ((DRY_RUN)); then
  info "Would create directory: $SKILLS_TARGET"
  info "Would create directory: $STATE_DIR"
else
  mkdir -p "$SKILLS_TARGET" "$STATE_DIR"
fi

# Preserve changed managed skills outside discovery before replacement or removal.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  target_dir="$SKILLS_TARGET/$skill"
  if ((DRY_RUN)); then
    info "Would back up modified managed skill: $target_dir -> $MODIFIED_SKILLS_BACKUPS/"
    continue
  fi

  mkdir -p "$MODIFIED_SKILLS_BACKUPS"
  backup=$(mktemp -d "$MODIFIED_SKILLS_BACKUPS/$skill.$(utc_stamp).XXXXXX")
  if ! cp -R "$target_dir"/. "$backup"/; then
    safe_remove_managed_dir "$backup" "$MODIFIED_SKILLS_BACKUPS"
    fail "Could not back up modified managed skill: $target_dir"
  fi
  info "Backed up modified managed skill: $target_dir -> $backup"
done < "$MODIFIED_SKILLS"

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
  atomic_copy_file "$PACKAGED_SKILLS" "$SKILLS_STATE"
  STAGED_HASHES=$(mktemp "$STATE_DIR/.skills.sha256.XXXXXX")
  while IFS= read -r skill; do
    printf '%s %s\n' "$skill" "$(dir_sha256 "$SKILLS_TARGET/$skill")" >> "$STAGED_HASHES"
  done < "$SKILLS_STATE"
  chmod 0600 "$STAGED_HASHES"
  mv -f "$STAGED_HASHES" "$SKILLS_HASHES"
  STAGED_HASHES=""
  state_set "$STATE_FILE" VERSION "$(cat "$ROOT_DIR/VERSION")"
  state_set "$STATE_FILE" PROFILE "$PROFILE"
  state_set "$STATE_FILE" SKILLS_TARGET "$SKILLS_TARGET"
  state_set "$STATE_FILE" AGENTS_TARGET "$AGENTS_TARGET"
  state_set "$STATE_FILE" INSTALLED_AT "$(utc_stamp)"
fi

if [[ "$AGENTS_MODE" == replace ]]; then
  if ((DRY_RUN)); then
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      info "Would back up modified managed language file: $LANG_TARGET/$relative -> $MODIFIED_LANG_BACKUPS/"
    done < "$MODIFIED_LANG"
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      info "Would install language default: $relative -> $LANG_TARGET/$relative"
    done < "$PACKAGED_LANG"
  else
    if [[ -s "$MODIFIED_LANG" ]]; then
      mkdir -p "$MODIFIED_LANG_BACKUPS"
      modified_backup_root=$(mktemp -d "$MODIFIED_LANG_BACKUPS/$(utc_stamp).XXXXXX")
      while IFS= read -r relative || [[ -n "$relative" ]]; do
        [[ -n "$relative" ]] || continue
        backup="$modified_backup_root/$relative"
        mkdir -p "$(dirname "$backup")"
        cp -p "$LANG_TARGET/$relative" "$backup"
        info "Backed up modified managed language file: $LANG_TARGET/$relative -> $backup"
      done < "$MODIFIED_LANG"
    fi

    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      if line_in_file "$relative" "$OLD_LANG" || line_in_file "$relative" "$PENDING_LANG"; then
        continue
      fi
      target="$LANG_TARGET/$relative"
      original=$(state_get "$ORIGINAL_LANG" "$relative" 2>/dev/null || true)
      if [[ -f "$target" && -z "$original" ]]; then
        backup="$LANG_BACKUPS/$relative.$(utc_stamp).backup"
        mkdir -p "$(dirname "$backup")"
        cp -p "$target" "$backup"
        state_set "$ORIGINAL_LANG" "$relative" "$backup"
        info "Backed up existing language file: $target -> $backup"
      fi
    done < "$PACKAGED_LANG"

    STAGED_LANG_HASHES=$(mktemp "$STATE_DIR/.lang.pending.sha256.XXXXXX")
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      printf '%s %s\n' "$relative" "$(sha256_file "$LANG_SOURCE/$relative")" >> "$STAGED_LANG_HASHES"
    done < "$PACKAGED_LANG"
    chmod 0600 "$STAGED_LANG_HASHES"
    mv -f "$STAGED_LANG_HASHES" "$LANG_PENDING_HASHES"
    STAGED_LANG_HASHES=""

    STAGED_LANG=$(mktemp -d "$AGENTS_ROOT/.engineering-os-lang.XXXXXX")
    if [[ -d "$LANG_TARGET" ]]; then
      cp -R "$LANG_TARGET"/. "$STAGED_LANG"/
    fi

    : > "$REMOVED_LANG_BACKUPS"
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      if line_in_file "$relative" "$PACKAGED_LANG"; then
        continue
      fi
      staged_target="$STAGED_LANG/$relative"
      original=$(state_get "$ORIGINAL_LANG" "$relative" 2>/dev/null || true)
      if [[ -n "$original" ]]; then
        atomic_copy_file "$original" "$staged_target"
        printf '%s=%s\n' "$relative" "$original" >> "$REMOVED_LANG_BACKUPS"
      else
        rm -f "$staged_target"
      fi
    done < "$OLD_LANG"

    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      atomic_copy_file "$LANG_SOURCE/$relative" "$STAGED_LANG/$relative"
    done < "$PACKAGED_LANG"

    atomic_replace_dir "$STAGED_LANG" "$LANG_TARGET"
    rm -rf "$STAGED_LANG"
    STAGED_LANG=""

    mv -f "$LANG_PENDING_HASHES" "$LANG_HASHES"
    state_set "$STATE_FILE" LANG_TARGET "$LANG_TARGET"
    state_set "$STATE_FILE" LANG_INVENTORY_SHA256 "$(sha256_file "$LANG_HASHES")"

    while IFS='=' read -r relative backup || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      rm -f "$backup"
      state_remove "$ORIGINAL_LANG" "$relative"
    done < "$REMOVED_LANG_BACKUPS"

    info "Installed language defaults: $LANG_TARGET"
  fi

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
