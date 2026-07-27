#!/usr/bin/env bash
set -euo pipefail

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
info() { printf '%s\n' "$*"; }

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

utc_stamp() { date -u '+%Y%m%dT%H%M%SZ'; }

atomic_copy() {
  local source=$1 target=$2 dir tmp
  dir=$(dirname "$target")
  mkdir -p "$dir"
  tmp=$(mktemp "$dir/.engineering-os-file.XXXXXX")
  cp "$source" "$tmp"
  chmod 0644 "$tmp"
  mv -f "$tmp" "$target"
}

atomic_copy_dir() {
  local source=$1 target=$2 parent tmp
  parent=$(dirname "$target")
  mkdir -p "$parent"
  tmp=$(mktemp -d "$parent/.engineering-os-dir.XXXXXX")
  cp -R "$source"/. "$tmp"/
  rm -rf "$target"
  mv "$tmp" "$target"
}

dir_sha256() {
  local dir=$1 rel file
  [[ -d "$dir" ]] || { printf 'missing\n'; return; }
  (
    cd "$dir"
    find . -type f | LC_ALL=C sort | while IFS= read -r rel; do
      file=${rel#./}
      printf '%s  %s\n' "$(sha256_file "$file")" "$file"
    done
  ) | {
    if command -v sha256sum >/dev/null 2>&1; then sha256sum | awk '{print $1}'
    else shasum -a 256 | awk '{print $1}'
    fi
  }
}

state_get() {
  local file=$1 key=$2
  [[ -f "$file" ]] || return 1
  awk -F= -v key="$key" '$1 == key {sub(/^[^=]*=/, ""); print; exit}' "$file"
}

state_set() {
  local file=$1 key=$2 value=$3 dir tmp
  dir=$(dirname "$file")
  mkdir -p "$dir"
  tmp=$(mktemp "$dir/.state.XXXXXX")
  if [[ -f "$file" ]]; then awk -F= -v key="$key" '$1 != key' "$file" > "$tmp"; fi
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  chmod 0600 "$tmp"
  mv -f "$tmp" "$file"
}
