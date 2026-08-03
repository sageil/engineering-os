#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2034
INSTALL_STATE_SCHEMA=1

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

sha256_file() {
  local file=$1
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$file" | awk '{print $1}'
  else
    fail "Neither sha256sum nor shasum is available."
  fi
}

utc_stamp() {
  date -u '+%Y%m%dT%H%M%SZ'
}

manifest_list() {
  local manifest=$1
  local key=$2
  awk '
    $0 == key ":" { inside = 1; next }
    inside && /^[^ ]/ { exit }
    inside && /^  - / { sub(/^  - /, ""); print }
  ' key="$key" "$manifest"
}

manifest_skills() {
  manifest_list "$1" skills
}

routing_skills() {
  local routing=$1
  awk '
    /^skills:$/ { inside = 1; next }
    inside && /^[^ ]/ { exit }
    inside && /^  [a-z0-9-]+:$/ {
      skill = $1
      sub(/:$/, "", skill)
      print skill
    }
  ' "$routing"
}

routing_skills_with_activation() {
  local routing=$1
  local wanted=$2
  awk '
    /^skills:$/ { inside = 1; next }
    inside && /^[^ ]/ { exit }
    inside && /^  [a-z0-9-]+:$/ {
      skill = $1
      sub(/:$/, "", skill)
      next
    }
    inside && /^    activation: / && $2 == wanted { print skill }
  ' wanted="$wanted" "$routing"
}

atomic_copy_file() {
  local source=$1
  local target=$2
  local directory
  local staged

  directory=$(dirname "$target")
  mkdir -p "$directory"
  staged=$(mktemp "$directory/.engineering-os-file.XXXXXX")
  cp "$source" "$staged"
  chmod 0644 "$staged"
  mv -f "$staged" "$target"
}

atomic_replace_dir() {
  local source=$1
  local target=$2
  local parent
  local staged
  local previous=""

  [[ -d "$source" ]] || fail "Source directory is missing: $source"
  parent=$(dirname "$target")
  mkdir -p "$parent"
  staged=$(mktemp -d "$parent/.engineering-os-new.XXXXXX")
  cp -R "$source"/. "$staged"/

  if [[ -d "$target" ]]; then
    previous=$(mktemp -d "$parent/.engineering-os-old.XXXXXX")
    rmdir "$previous"
    mv "$target" "$previous"
  elif [[ -e "$target" ]]; then
    rm -rf "$staged"
    fail "Directory target exists as another file type: $target"
  fi

  if mv "$staged" "$target"; then
    if [[ -n "$previous" ]]; then
      rm -rf "$previous"
    fi
    return
  fi

  rm -rf "$staged"
  if [[ -n "$previous" && ! -e "$target" ]]; then
    mv "$previous" "$target" || true
  fi
  fail "Could not replace directory safely: $target"
}

safe_remove_managed_dir() {
  local target=$1
  local root=$2

  [[ -n "$target" && -n "$root" ]] || fail "Refusing to remove an unresolved path."
  [[ "$root" != / && "$target" != / && "$target" != "$root" ]] || fail "Refusing to remove a broad path: $target"
  case "$target" in
    "$root"/*) ;;
    *) fail "Refusing to remove a path outside the managed root: $target" ;;
  esac
  rm -rf "$target"
}

dir_sha256() {
  local directory=$1
  local relative
  local file

  [[ -d "$directory" ]] || {
    printf 'missing\n'
    return
  }

  (
    cd "$directory"
    find . -type f | LC_ALL=C sort | while IFS= read -r relative; do
      file=${relative#./}
      printf '%s  %s\n' "$(sha256_file "$file")" "$file"
    done
  ) | {
    if command -v sha256sum >/dev/null 2>&1; then
      sha256sum | awk '{print $1}'
    else
      shasum -a 256 | awk '{print $1}'
    fi
  }
}

state_get() {
  local file=$1
  local key=$2
  [[ -f "$file" ]] || return 1
  awk -F= -v key="$key" '$1 == key { sub(/^[^=]*=/, ""); print; exit }' "$file"
}

state_set() {
  local file=$1
  local key=$2
  local value=$3
  local directory
  local staged

  directory=$(dirname "$file")
  mkdir -p "$directory"
  staged=$(mktemp "$directory/.state.XXXXXX")
  if [[ -f "$file" ]]; then
    awk -F= -v key="$key" '$1 != key' "$file" > "$staged"
  fi
  printf '%s=%s\n' "$key" "$value" >> "$staged"
  chmod 0600 "$staged"
  mv -f "$staged" "$file"
}

state_remove() {
  local file=$1
  local key=$2
  local directory
  local staged

  [[ -f "$file" ]] || return 0
  directory=$(dirname "$file")
  staged=$(mktemp "$directory/.state.XXXXXX")
  awk -F= -v key="$key" '$1 != key' "$file" > "$staged"
  chmod 0600 "$staged"
  mv -f "$staged" "$file"
}

line_in_file() {
  local value=$1
  local file=$2
  [[ -f "$file" ]] && grep -Fqx "$value" "$file"
}
