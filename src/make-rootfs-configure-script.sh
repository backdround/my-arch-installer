#!/usr/bin/env bash
set -euo pipefail

error() {
  echo "$@" >&2
  exit 1
}

# Extracts injected directory from current file (where it is executed)
selfextract() {
  local directory_to_extract="${1:-}"
  local label="${2:-}"
  test -d "$directory_to_extract" || error "Directory to extract must be set"
  test -n "$label" || error "Label must be set"

  current_file="$0"

  # Gets boundaries
  local begin_separator_line="$(grep -n -e "^-----BEGIN $label-----$" "$current_file" | cut -f1 -d:)"
  local begin_entry_line="$((begin_separator_line + 1))"

  local end_separator_line="$(grep -n -e "^-----END $label-----$" "$current_file" | cut -f1 -d:)"
  local end_entry_line="$((end_separator_line - 1))"

  # Gets injected contents
  output_entry() {
    head -n "$end_entry_line" "$current_file" | tail -n "+$begin_entry_line"
  }

  # Decodes contents
  decode_directory() {
    base64 -d | gunzip \
      | tar --preserve-permissions -xf - -C $directory_to_extract
  }

  # Extracts injected directory
  output_entry | decode_directory
}

inject-directory-in-file() {
  local file="${1:-}"
  local directory_to_archive="${2:-}"
  local label="${3:-}"

  test -f "$file" || error "File to inject must be exist"
  test -d "$directory_to_archive" || \
    error "There is no directory: $directory_to_archive"
  test -n "$label" || asert "Label must be set"

  # Injects directory
  echo "-----BEGIN $label-----" >> "$file"
  tar -cf - --exclude=.git --directory="$directory_to_archive" . \
      | gzip -5 | base64 >> "$file"
  echo "-----END $label-----" >> "$file"
}


script_path_to_build="${1:-}"
test -n "$script_path_to_build" || {
  error "Script path to build must be set"
}
mkdir -p "$(dirname "$script_path_to_build")"

# Generates configure rootfs script which extracts install script
label="$(echo $RANDOM | md5sum | head -c 15)"
cat > "$script_path_to_build" <<EOF
#!/usr/bin/env bash
set -euo pipefail

mkdir /root/installation-script

$(declare -f selfextract)
selfextract /root/installation-script "$label"
exit 0
EOF

inject-directory-in-file "$script_path_to_build" ./archlive-installation-script "$label"
chmod +x "$script_path_to_build"
