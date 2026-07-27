#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

AGENTS_MODE=""
DRY_RUN=0
AGENTS_TARGET="${HOME}/.agents/AGENTS.md"

usage() {
  cat <<USAGE
Usage: $0 [--agents keep|restore] [--agents-target PATH] [--dry-run]

Options:
  --agents keep       Preserve a modified current AGENTS.md (default).
  --agents restore    Restore the pre-installation AGENTS.md; preserve edits first.
  --agents-target     AGENTS.md path (default: ~/.agents/AGENTS.md).
  --dry-run           Show operations without changing files.
  -h, --help          Show this help.
USAGE
}
while (($#)); do
  case "$1" in
    --agents) [[ $# -ge 2 ]] || fail "--agents requires a value"; AGENTS_MODE=$2; shift 2 ;;
    --agents-target) [[ $# -ge 2 ]] || fail "--agents-target requires a path"; AGENTS_TARGET=$2; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Unknown argument: $1" ;;
  esac
done
[[ -z "$AGENTS_MODE" || "$AGENTS_MODE" == keep || "$AGENTS_MODE" == restore ]] || fail "--agents must be keep or restore"

STATE_DIR="$(dirname "$AGENTS_TARGET")/.engineering-os"
STATE_FILE="$STATE_DIR/install-state.env"
SKILLS_STATE="$STATE_DIR/skills.list"
SKILLS_HASHES="$STATE_DIR/skills.sha256"
[[ -f "$STATE_FILE" ]] || { info "No Engineering OS installation state found."; exit 0; }
SKILLS_TARGET=$(state_get "$STATE_FILE" SKILLS_TARGET)
STATE_AGENTS_TARGET=$(state_get "$STATE_FILE" AGENTS_TARGET)
[[ "$STATE_AGENTS_TARGET" == "$AGENTS_TARGET" ]] || fail "State target mismatch: $STATE_AGENTS_TARGET"

if [[ -f "$SKILLS_STATE" ]]; then
  while IFS= read -r skill || [[ -n "$skill" ]]; do
    [[ -n "$skill" ]] || continue
    target="$SKILLS_TARGET/$skill"
    installed_hash=$(awk -v s="$skill" '$1 == s {print $2; exit}' "$SKILLS_HASHES")
    if [[ -d "$target" ]]; then
      current_hash=$(dir_sha256 "$target")
      if [[ "$current_hash" != "$installed_hash" ]]; then
        info "Preserved modified skill: $target"
        continue
      fi
      original=$(awk -F= -v s="$skill" '$1 == s {sub(/^[^=]*=/, ""); print; exit}' "$STATE_DIR/original-skills.env" 2>/dev/null || true)
      if [[ -n "$original" && -d "$original" ]]; then
        if ((DRY_RUN)); then info "Would restore original skill: $original -> $target"
        else rm -rf "$target"; mv "$original" "$target"; info "Restored original skill: $skill"; fi
      else
        if ((DRY_RUN)); then info "Would remove skill: $target"
        else rm -rf "$target"; info "Removed skill: $skill"; fi
      fi
    fi
  done < "$SKILLS_STATE"
fi

ACTION=$(state_get "$STATE_FILE" AGENTS_ACTION 2>/dev/null || true)
if [[ "$ACTION" == replace ]]; then
  installed_sha=$(state_get "$STATE_FILE" AGENTS_INSTALLED_SHA256 2>/dev/null || true)
  original_existed=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_EXISTED 2>/dev/null || printf '0')
  original_backup=$(state_get "$STATE_FILE" AGENTS_ORIGINAL_BACKUP 2>/dev/null || true)
  current_changed=0
  if [[ -f "$AGENTS_TARGET" ]]; then [[ "$(sha256_file "$AGENTS_TARGET")" == "$installed_sha" ]] || current_changed=1; fi

  if [[ $current_changed -eq 1 && -z "$AGENTS_MODE" && -t 0 ]]; then
    cat <<MENU
$AGENTS_TARGET has changed since Engineering OS installed it.

  1. Keep the current file (default)
  2. Back up the current file, then restore the pre-installation state
  3. Cancel
MENU
    read -r -p '> ' choice || choice=1
    case "${choice:-1}" in 1) AGENTS_MODE=keep ;; 2) AGENTS_MODE=restore ;; 3) info "Uninstall cancelled."; exit 0 ;; *) AGENTS_MODE=keep ;; esac
  elif [[ $current_changed -eq 1 && -z "$AGENTS_MODE" ]]; then AGENTS_MODE=keep
  fi

  if [[ $current_changed -eq 1 && "$AGENTS_MODE" == keep ]]; then
    info "Kept modified AGENTS.md: $AGENTS_TARGET"
  else
    if [[ $current_changed -eq 1 ]]; then
      preserved="$STATE_DIR/backups/agents/AGENTS.md.pre-uninstall.$(utc_stamp).backup"
      if ((DRY_RUN)); then info "Would preserve current AGENTS.md: $preserved"
      else mkdir -p "$(dirname "$preserved")"; cp -p "$AGENTS_TARGET" "$preserved"; chmod 0600 "$preserved" 2>/dev/null || true; info "Preserved modified AGENTS.md: $preserved"; fi
    fi
    if [[ "$original_existed" == 1 ]]; then
      [[ -f "$original_backup" ]] || fail "Original AGENTS.md backup is missing: $original_backup"
      if ((DRY_RUN)); then info "Would restore: $original_backup -> $AGENTS_TARGET"
      else atomic_copy "$original_backup" "$AGENTS_TARGET"; info "Restored original AGENTS.md."; fi
    else
      if ((DRY_RUN)); then info "Would remove Engineering OS-created AGENTS.md: $AGENTS_TARGET"
      else rm -f "$AGENTS_TARGET"; info "Removed Engineering OS-created AGENTS.md."; fi
    fi
  fi
fi

if ((DRY_RUN)); then info "Would remove installation state where safe."
else
  # Retain backups when modified user content remains; otherwise clean the state tree.
  if [[ -d "$STATE_DIR/backups" ]] && find "$STATE_DIR/backups" -type f | grep -q .; then
    rm -f "$STATE_FILE" "$SKILLS_STATE" "$SKILLS_HASHES"
    info "Backups retained under: $STATE_DIR/backups"
  else rm -rf "$STATE_DIR"; fi
  info "Engineering OS uninstall complete."
fi
