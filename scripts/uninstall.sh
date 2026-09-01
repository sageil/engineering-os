#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common.sh"

AGENTS_MODE=""
DRY_RUN=0
AGENTS_TARGET="${HOME}/.agents/AGENTS.md"

usage() {
  cat <<USAGE
Usage: $0 [--agents keep|restore] [--agents-target PATH] [--dry-run]

Options:
  --agents keep       Preserve a modified current AGENTS.md (default).
  --agents restore    Preserve edits as a backup, then restore the pre-installation state.
  --agents-target     AGENTS.md path (default: ~/.agents/AGENTS.md).
  --dry-run           Show operations without changing files.
  -h, --help          Show this help.
USAGE
}

while (($#)); do
  case "$1" in
    --agents)
      [[ $# -ge 2 ]] || fail "--agents requires a value"
      AGENTS_MODE=$2
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

[[ -z "$AGENTS_MODE" || "$AGENTS_MODE" == keep || "$AGENTS_MODE" == restore ]] || fail "--agents must be keep or restore"
[[ -n "$AGENTS_TARGET" && "$AGENTS_TARGET" != / ]] || fail "Refusing broad AGENTS.md target: $AGENTS_TARGET"

STATE_DIR="$(dirname "$AGENTS_TARGET")/.engineering-os"
STATE_FILE="$STATE_DIR/install-state.env"
SKILLS_STATE="$STATE_DIR/skills.list"
SKILLS_HASHES="$STATE_DIR/skills.sha256"
ORIGINAL_SKILLS="$STATE_DIR/original-skills.env"
LANG_HASHES="$STATE_DIR/lang.sha256"
LANG_PENDING_HASHES="$STATE_DIR/lang.pending.sha256"
ORIGINAL_LANG="$STATE_DIR/original-lang.env"
SKILLS_BACKUPS="$STATE_DIR/backups/skills"
AGENTS_BACKUPS="$STATE_DIR/backups/agents"
LANG_BACKUPS="$STATE_DIR/backups/lang"
MODIFIED_LANG_BACKUPS="$STATE_DIR/backups/modified-lang"
HASH_SKILLS=$(mktemp)
HASH_LANG=$(mktemp)
MANAGED_LANG=$(mktemp)
MODIFIED_LANG=$(mktemp)
STAGED_LANG=""
cleanup() {
  rm -f "$HASH_SKILLS" "$HASH_LANG" "$MANAGED_LANG" "$MODIFIED_LANG"
  if [[ -n "$STAGED_LANG" ]]; then
    rm -rf "$STAGED_LANG"
  fi
}
trap cleanup EXIT

[[ -f "$STATE_FILE" ]] || {
  info "No Engineering OS installation state found."
  exit 0
}
[[ -f "$SKILLS_STATE" ]] || fail "Installation state is missing skills.list."
[[ -f "$SKILLS_HASHES" ]] || fail "Installation state is missing skills.sha256."
[[ ! -e "$LANG_PENDING_HASHES" ]] || fail "Language installation is incomplete. Rerun the installer before uninstalling."

SKILLS_TARGET=$(state_get "$STATE_FILE" SKILLS_TARGET 2>/dev/null || true)
STATE_AGENTS_TARGET=$(state_get "$STATE_FILE" AGENTS_TARGET 2>/dev/null || true)
[[ "$STATE_AGENTS_TARGET" == "$AGENTS_TARGET" ]] || fail "State target mismatch: $STATE_AGENTS_TARGET"
[[ -n "$SKILLS_TARGET" && "$SKILLS_TARGET" != / ]] || fail "Invalid skills target in state: $SKILLS_TARGET"
LANG_TARGET="$(dirname "$AGENTS_TARGET")/lang"
STATE_LANG_TARGET=$(state_get "$STATE_FILE" LANG_TARGET 2>/dev/null || true)
if [[ -f "$LANG_HASHES" ]]; then
  [[ "$STATE_LANG_TARGET" == "$LANG_TARGET" ]] || fail "Language state target mismatch: ${STATE_LANG_TARGET:-missing}"
fi

duplicate=$(LC_ALL=C sort "$SKILLS_STATE" | uniq -d)
[[ -z "$duplicate" ]] || fail "Installation state contains a duplicate skill: $duplicate"
awk 'NF { if (NF != 2 || $1 !~ /^[a-z0-9-]+$/ || $2 !~ /^[0-9a-f]+$/ || length($2) != 64) exit 1; print $1 }' "$SKILLS_HASHES" > "$HASH_SKILLS" || fail "Installation state contains an invalid skill hash record."
cmp -s <(LC_ALL=C sort "$SKILLS_STATE") <(LC_ALL=C sort "$HASH_SKILLS") || fail "Installed skill and hash inventories do not match."

if [[ -f "$ORIGINAL_SKILLS" ]]; then
  while IFS='=' read -r skill backup || [[ -n "$skill" ]]; do
    [[ -n "$skill" ]] || continue
    line_in_file "$skill" "$SKILLS_STATE" || fail "Skill backup mapping is not managed: $skill"
    case "$backup" in
      "$SKILLS_BACKUPS"/*) ;;
      *) fail "Skill backup is outside the managed backup root: $backup" ;;
    esac
    [[ -d "$backup" ]] || fail "Pre-installation skill backup is missing: $backup"
  done < "$ORIGINAL_SKILLS"
fi

if [[ -f "$LANG_HASHES" ]]; then
  recorded_lang_inventory_hash=$(state_get "$STATE_FILE" LANG_INVENTORY_SHA256 2>/dev/null || true)
  [[ -s "$LANG_HASHES" ]] || fail "Installation state contains an empty language inventory."
  [[ -n "$recorded_lang_inventory_hash" ]] || fail "Installation state is missing the language inventory hash."
  [[ "$(sha256_file "$LANG_HASHES")" == "$recorded_lang_inventory_hash" ]] || fail "Installed language inventory does not match its recorded hash."
  awk 'NF { if (NF != 2 || $1 !~ /^[a-zA-Z0-9._\/-]+$/ || $2 !~ /^[0-9a-f]+$/ || length($2) != 64) exit 1; print $1 }' "$LANG_HASHES" > "$HASH_LANG" || fail "Installation state contains an invalid language hash record."
  cp "$HASH_LANG" "$MANAGED_LANG"
  duplicate=$(LC_ALL=C sort "$MANAGED_LANG" | uniq -d)
  [[ -z "$duplicate" ]] || fail "Installation state contains a duplicate language path: $duplicate"
elif [[ -e "$ORIGINAL_LANG" ]]; then
  fail "Partial language installation state exists without lang.sha256."
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

# Preflight every managed skill before removing any file.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  case "$skill" in
    *[!a-z0-9-]*) fail "Installation state contains an invalid skill name: $skill" ;;
  esac

  target="$SKILLS_TARGET/$skill"
  installed_hash=$(awk -v s="$skill" '$1 == s { print $2; exit }' "$SKILLS_HASHES")
  [[ -n "$installed_hash" ]] || fail "Installation state is missing a hash for: $skill"
  [[ ! -e "$target" || -d "$target" ]] || fail "Managed skill target is not a directory: $target"

  original=$(state_get "$ORIGINAL_SKILLS" "$skill" 2>/dev/null || true)
  if [[ -n "$original" ]]; then
    case "$original" in
      "$SKILLS_BACKUPS"/*) ;;
      *) fail "Skill backup is outside the managed backup root: $original" ;;
    esac
    [[ -d "$original" ]] || fail "Pre-installation skill backup is missing: $original"
  fi
done < "$SKILLS_STATE"

if [[ -s "$MANAGED_LANG" ]]; then
  if [[ -L "$LANG_TARGET" || ( -e "$LANG_TARGET" && ! -d "$LANG_TARGET" ) ]]; then
    fail "Managed language target is not a regular directory: $LANG_TARGET"
  fi
  while IFS= read -r relative || [[ -n "$relative" ]]; do
    [[ -n "$relative" ]] || continue
    target="$LANG_TARGET/$relative"
    installed_hash=$(awk -v p="$relative" '$1 == p { print $2; exit }' "$LANG_HASHES")
    [[ -n "$installed_hash" ]] || fail "Installation state is missing a language hash for: $relative"
    if [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
      fail "Managed language target is not a regular file: $target"
    fi
  done < "$MANAGED_LANG"
fi

ACTION=$(state_get "$STATE_FILE" AGENTS_ACTION 2>/dev/null || true)
[[ "$ACTION" == keep || "$ACTION" == replace ]] || fail "Installation state contains an unsupported AGENTS.md action: ${ACTION:-missing}"

installed_agents_hash=""
original_existed=0
original_backup=""
current_changed=0
language_changed=0
: > "$MODIFIED_LANG"

while IFS= read -r relative || [[ -n "$relative" ]]; do
  [[ -n "$relative" ]] || continue
  target="$LANG_TARGET/$relative"
  installed_hash=$(awk -v p="$relative" '$1 == p { print $2; exit }' "$LANG_HASHES")
  if [[ -f "$target" && "$(sha256_file "$target")" != "$installed_hash" ]]; then
    printf '%s\n' "$relative" >> "$MODIFIED_LANG"
    language_changed=1
  fi
done < "$MANAGED_LANG"

if [[ "$ACTION" == replace ]]; then
  installed_agents_hash=$(state_get "$STATE_FILE" AGENTS_INSTALLED_SHA256 2>/dev/null || true)
  original_existed=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 2>/dev/null || true)
  original_backup=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_BACKUP 2>/dev/null || true)

  [[ -n "$installed_agents_hash" ]] || fail "Installation state is missing the installed AGENTS.md hash."
  [[ "$original_existed" == 0 || "$original_existed" == 1 ]] || fail "Installation state contains an invalid AGENTS.md origin flag."
  [[ ! -e "$AGENTS_TARGET" || -f "$AGENTS_TARGET" ]] || fail "Managed AGENTS.md target is not a regular file: $AGENTS_TARGET"

  if [[ "$original_existed" == 1 ]]; then
    case "$original_backup" in
      "$AGENTS_BACKUPS"/*) ;;
      *) fail "AGENTS.md backup is outside the managed backup root: $original_backup" ;;
    esac
    [[ -f "$original_backup" ]] || fail "Original AGENTS.md backup is missing: $original_backup"
  fi

  if [[ -f "$AGENTS_TARGET" && "$(sha256_file "$AGENTS_TARGET")" != "$installed_agents_hash" ]]; then
    current_changed=1
  fi
fi

if [[ ( $current_changed -eq 1 || $language_changed -eq 1 ) && -z "$AGENTS_MODE" && -t 0 ]]; then
    cat <<MENU
The installed global policy or language defaults changed after Engineering OS installed them.

  1. Keep the changed files (default)
  2. Preserve the changed files as backups, then restore the pre-installation state
  3. Cancel
MENU
    read -r -p '> ' choice || choice=1
    case "${choice:-1}" in
      1) AGENTS_MODE=keep ;;
      2) AGENTS_MODE=restore ;;
      3) info "Uninstall cancelled."; exit 0 ;;
      *) AGENTS_MODE=keep ;;
    esac
elif [[ ( $current_changed -eq 1 || $language_changed -eq 1 ) && -z "$AGENTS_MODE" ]]; then
  AGENTS_MODE=keep
fi

# Remove unchanged managed skills and restore pre-installation collisions.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  target="$SKILLS_TARGET/$skill"
  installed_hash=$(awk -v s="$skill" '$1 == s { print $2; exit }' "$SKILLS_HASHES")
  original=$(state_get "$ORIGINAL_SKILLS" "$skill" 2>/dev/null || true)

  if [[ -d "$target" && "$(dir_sha256 "$target")" != "$installed_hash" ]]; then
    info "Preserved modified skill: $target"
    continue
  fi

  if [[ -n "$original" ]]; then
    if ((DRY_RUN)); then
      info "Would restore original skill: $original -> $target"
    else
      atomic_replace_dir "$original" "$target"
      safe_remove_managed_dir "$original" "$SKILLS_BACKUPS"
      state_remove "$ORIGINAL_SKILLS" "$skill"
      info "Restored original skill: $skill"
    fi
  elif [[ -d "$target" ]]; then
    if ((DRY_RUN)); then
      info "Would remove unchanged managed skill: $target"
    else
      safe_remove_managed_dir "$target" "$SKILLS_TARGET"
      info "Removed managed skill: $skill"
    fi
  fi
done < "$SKILLS_STATE"

if [[ -s "$MANAGED_LANG" ]]; then
  if ((DRY_RUN)); then
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      if line_in_file "$relative" "$MODIFIED_LANG" && [[ "$AGENTS_MODE" == keep ]]; then
        info "Would keep modified language file: $LANG_TARGET/$relative"
        continue
      fi
      original=$(state_get "$ORIGINAL_LANG" "$relative" 2>/dev/null || true)
      if [[ -n "$original" ]]; then
        info "Would restore original language file: $original -> $LANG_TARGET/$relative"
      else
        info "Would remove managed language file: $LANG_TARGET/$relative"
      fi
    done < "$MANAGED_LANG"
  else
    if [[ -s "$MODIFIED_LANG" && "$AGENTS_MODE" == restore ]]; then
      mkdir -p "$MODIFIED_LANG_BACKUPS"
      modified_backup_root=$(mktemp -d "$MODIFIED_LANG_BACKUPS/pre-uninstall.$(utc_stamp).XXXXXX")
      while IFS= read -r relative || [[ -n "$relative" ]]; do
        [[ -n "$relative" ]] || continue
        backup="$modified_backup_root/$relative"
        mkdir -p "$(dirname "$backup")"
        cp -p "$LANG_TARGET/$relative" "$backup"
        info "Preserved modified language file: $backup"
      done < "$MODIFIED_LANG"
    fi

    STAGED_LANG=$(mktemp -d "$(dirname "$LANG_TARGET")/.engineering-os-lang.XXXXXX")
    if [[ -d "$LANG_TARGET" ]]; then
      cp -R "$LANG_TARGET"/. "$STAGED_LANG"/
    fi
    while IFS= read -r relative || [[ -n "$relative" ]]; do
      [[ -n "$relative" ]] || continue
      if line_in_file "$relative" "$MODIFIED_LANG" && [[ "$AGENTS_MODE" == keep ]]; then
        info "Kept modified language file: $LANG_TARGET/$relative"
        continue
      fi
      staged_target="$STAGED_LANG/$relative"
      original=$(state_get "$ORIGINAL_LANG" "$relative" 2>/dev/null || true)
      if [[ -n "$original" ]]; then
        atomic_copy_file "$original" "$staged_target"
        info "Restored original language file: $relative"
      else
        rm -f "$staged_target"
        info "Removed managed language file: $relative"
      fi
    done < "$MANAGED_LANG"
    atomic_replace_dir "$STAGED_LANG" "$LANG_TARGET"
    rm -rf "$STAGED_LANG"
    STAGED_LANG=""
    rmdir "$LANG_TARGET" 2>/dev/null || true
  fi
fi

if [[ "$ACTION" == replace ]]; then
  if [[ $current_changed -eq 1 && "$AGENTS_MODE" == keep ]]; then
    info "Kept modified AGENTS.md: $AGENTS_TARGET"
  else
    if [[ $current_changed -eq 1 ]]; then
      preserved="$AGENTS_BACKUPS/AGENTS.md.pre-uninstall.$(utc_stamp).backup"
      if ((DRY_RUN)); then
        info "Would preserve current AGENTS.md: $preserved"
      else
        mkdir -p "$AGENTS_BACKUPS"
        cp -p "$AGENTS_TARGET" "$preserved"
        chmod 0600 "$preserved" 2>/dev/null || true
        info "Preserved modified AGENTS.md: $preserved"
      fi
    fi

    if [[ "$original_existed" == 1 ]]; then
      if ((DRY_RUN)); then
        info "Would restore original AGENTS.md: $original_backup -> $AGENTS_TARGET"
      else
        atomic_copy_file "$original_backup" "$AGENTS_TARGET"
        info "Restored original AGENTS.md."
      fi
    else
      if ((DRY_RUN)); then
        info "Would remove Engineering OS-created AGENTS.md: $AGENTS_TARGET"
      else
        rm -f "$AGENTS_TARGET"
        info "Removed Engineering OS-created AGENTS.md."
      fi
    fi
  fi
fi

if ((DRY_RUN)); then
  info "Would remove installation state where safe."
  exit 0
fi

rm -f "$STATE_FILE" "$SKILLS_STATE" "$SKILLS_HASHES" "$LANG_HASHES" "$ORIGINAL_LANG"
if [[ -f "$ORIGINAL_SKILLS" && ! -s "$ORIGINAL_SKILLS" ]]; then
  rm -f "$ORIGINAL_SKILLS"
fi

if [[ -d "$STATE_DIR/backups" ]] && find "$STATE_DIR/backups" -type f | grep -q .; then
  info "Backups retained under: $STATE_DIR/backups"
else
  rm -rf "$STATE_DIR"
fi

info "Engineering OS uninstall complete."
