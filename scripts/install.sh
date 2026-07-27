#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

AGENTS_MODE=""
DRY_RUN=0
SKILLS_TARGET="${HOME}/.agents/skills"
AGENTS_TARGET="${HOME}/.agents/AGENTS.md"
GLOBAL_POLICY="$ROOT_DIR/global-agents.md"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --agents keep|replace  Keep or replace the global AGENTS.md.
  --skills-target PATH   Skills directory (default: ~/.agents/skills).
  --agents-target PATH   AGENTS.md path (default: ~/.agents/AGENTS.md).
  --dry-run              Show operations without changing files.
  -h, --help             Show this help.
USAGE
}

while (($#)); do
  case "$1" in
    --agents) [[ $# -ge 2 ]] || fail "--agents requires a value"; AGENTS_MODE=$2; shift 2 ;;
    --skills-target) [[ $# -ge 2 ]] || fail "--skills-target requires a path"; SKILLS_TARGET=$2; shift 2 ;;
    --agents-target) [[ $# -ge 2 ]] || fail "--agents-target requires a path"; AGENTS_TARGET=$2; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Unknown argument: $1" ;;
  esac
done

[[ -z "$AGENTS_MODE" || "$AGENTS_MODE" == keep || "$AGENTS_MODE" == replace ]] || fail "--agents must be keep or replace"
[[ -f "$GLOBAL_POLICY" ]] || fail "Packaged global policy not found: $GLOBAL_POLICY"

AGENTS_ROOT=$(dirname "$AGENTS_TARGET")
STATE_DIR="$AGENTS_ROOT/.engineering-os"
STATE_FILE="$STATE_DIR/install-state.env"
SKILLS_STATE="$STATE_DIR/skills.list"
SKILLS_HASHES="$STATE_DIR/skills.sha256"
SKILLS_BACKUPS="$STATE_DIR/backups/skills"
AGENTS_BACKUPS="$STATE_DIR/backups/agents"

if [[ -z "$AGENTS_MODE" ]]; then
  if [[ -t 0 ]]; then
    printf '\nEngineering OS installs skills into:\n  %s\n\n' "$SKILLS_TARGET"
    printf 'The global policy is optional:\n  %s\n\n' "$AGENTS_TARGET"
    cat <<MENU
Choose an AGENTS.md option:
  1. Keep the existing file unchanged (default)
  2. Replace/install Engineering OS AGENTS.md
  3. Show the proposed AGENTS.md
  4. Cancel
MENU
    while true; do
      read -r -p '> ' choice || choice=1
      case "${choice:-1}" in
        1) AGENTS_MODE=keep; break ;;
        2) AGENTS_MODE=replace; break ;;
        3) printf '\n--- Proposed AGENTS.md ---\n'; cat "$GLOBAL_POLICY"; printf '\n--- End ---\n\n' ;;
        4) info "Installation cancelled."; exit 0 ;;
        *) info "Choose 1, 2, 3, or 4." ;;
      esac
    done
  else
    AGENTS_MODE=keep
  fi
fi

NEW_SKILLS_LIST=$(mktemp)
trap 'rm -f "$NEW_SKILLS_LIST"' EXIT
while IFS= read -r source_dir; do
  skill=${source_dir##*/}
  [[ -f "$source_dir/SKILL.md" ]] || fail "Invalid packaged skill: $skill"
  printf '%s\n' "$skill" >> "$NEW_SKILLS_LIST"
done < <(find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)
[[ -s "$NEW_SKILLS_LIST" ]] || fail "No packaged skills found"

# Validate every managed target before changing any installation files.
while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  source_dir="$ROOT_DIR/skills/$skill"
  target_dir="$SKILLS_TARGET/$skill"

  if [[ -f "$SKILLS_HASHES" ]]; then
    old_hash=$(awk -v s="$skill" '$1 == s {print $2; exit}' "$SKILLS_HASHES")
  else
    old_hash=""
  fi

  if [[ -d "$target_dir" && -n "$old_hash" ]]; then
    current_hash=$(dir_sha256 "$target_dir")
    [[ "$current_hash" == "$old_hash" ]] || fail "Installed skill changed since installation: $target_dir. Preserve or remove it before updating."
  elif [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
    fail "Skill target exists but is not a directory: $target_dir"
  fi
done < "$NEW_SKILLS_LIST"

managed_sha=$(state_get "$STATE_FILE" AGENTS_INSTALLED_SHA256 2>/dev/null || true)
existing_agents_action=$(state_get "$STATE_FILE" AGENTS_ACTION 2>/dev/null || true)
if [[ "$AGENTS_MODE" == replace ]]; then
  if [[ -f "$AGENTS_TARGET" && -n "$managed_sha" ]]; then
    current_sha=$(sha256_file "$AGENTS_TARGET")
    [[ "$current_sha" == "$managed_sha" ]] || fail "AGENTS.md changed since installation. Resolve it before updating."
  elif [[ -e "$AGENTS_TARGET" && ! -f "$AGENTS_TARGET" ]]; then
    fail "AGENTS.md target exists but is not a regular file: $AGENTS_TARGET"
  fi
fi

mkdir_cmd() {
  if ((DRY_RUN)); then
    info "Would create directory: $1"
  else
    mkdir -p "$1"
  fi
}
mkdir_cmd "$SKILLS_TARGET"
mkdir_cmd "$STATE_DIR"

while IFS= read -r skill || [[ -n "$skill" ]]; do
  [[ -n "$skill" ]] || continue
  source_dir="$ROOT_DIR/skills/$skill"
  target_dir="$SKILLS_TARGET/$skill"
  if [[ -f "$SKILLS_HASHES" ]]; then
    old_hash=$(awk -v s="$skill" '$1 == s {print $2; exit}' "$SKILLS_HASHES")
  else
    old_hash=""
  fi

  if [[ -d "$target_dir" && -z "$old_hash" ]]; then
    backup="$SKILLS_BACKUPS/$skill.$(utc_stamp)"
    if ((DRY_RUN)); then
      info "Would back up existing skill: $target_dir -> $backup"
    else
      mkdir -p "$SKILLS_BACKUPS"
      cp -R "$target_dir" "$backup"
      printf '%s=%s\n' "$skill" "$backup" >> "$STATE_DIR/original-skills.env"
    fi
  fi

  if ((DRY_RUN)); then
    info "Would install skill: $skill -> $target_dir"
  else
    atomic_copy_dir "$source_dir" "$target_dir"
  fi
done < "$NEW_SKILLS_LIST"

skill_count=$(wc -l < "$NEW_SKILLS_LIST" | tr -d ' ')
if ((DRY_RUN)); then
  info "Would record installation state for $skill_count skills"
else
  cp "$NEW_SKILLS_LIST" "$SKILLS_STATE"
  : > "$SKILLS_HASHES"
  while IFS= read -r skill; do
    printf '%s %s\n' "$skill" "$(dir_sha256 "$SKILLS_TARGET/$skill")" >> "$SKILLS_HASHES"
  done < "$SKILLS_STATE"
  state_set "$STATE_FILE" VERSION "$(cat "$ROOT_DIR/VERSION")"
  state_set "$STATE_FILE" SKILLS_TARGET "$SKILLS_TARGET"
  state_set "$STATE_FILE" AGENTS_TARGET "$AGENTS_TARGET"
  state_set "$STATE_FILE" INSTALLED_AT "$(utc_stamp)"
fi

if [[ "$AGENTS_MODE" == replace ]]; then
  source_sha=$(sha256_file "$GLOBAL_POLICY")
  if [[ -f "$AGENTS_TARGET" && -z "$managed_sha" ]]; then
    backup="$AGENTS_BACKUPS/AGENTS.md.$(utc_stamp).backup"
    if ((DRY_RUN)); then info "Would back up: $AGENTS_TARGET -> $backup"
    else
      mkdir -p "$AGENTS_BACKUPS"; cp -p "$AGENTS_TARGET" "$backup"; chmod 0600 "$backup" 2>/dev/null || true
      state_set "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 1
      state_set "$STATE_FILE" AGENTS_ORIGINAL_BACKUP "$backup"
      state_set "$STATE_FILE" AGENTS_ORIGINAL_SHA256 "$(sha256_file "$AGENTS_TARGET")"
    fi
  elif [[ ! -e "$AGENTS_TARGET" && -z "$managed_sha" ]]; then
    ((DRY_RUN)) || state_set "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 0
  fi
  if ((DRY_RUN)); then
    info "Would install global policy: $AGENTS_TARGET"
  else
    atomic_copy "$GLOBAL_POLICY" "$AGENTS_TARGET"
    state_set "$STATE_FILE" AGENTS_ACTION replace
    state_set "$STATE_FILE" AGENTS_INSTALLED_SHA256 "$source_sha"
    info "Installed global policy: $AGENTS_TARGET"
  fi
else
  info "AGENTS.md left unchanged."
  if ((!DRY_RUN)) && [[ -z "$existing_agents_action" ]]; then
    state_set "$STATE_FILE" AGENTS_ACTION keep
  fi
fi

if ((DRY_RUN)); then
  info "Dry run complete. No files changed."
else
  info "Installed Engineering OS $(cat "$ROOT_DIR/VERSION") with $skill_count skills."
  info "Skills: $SKILLS_TARGET"
fi
