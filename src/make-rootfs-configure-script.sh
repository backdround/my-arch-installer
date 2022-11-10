#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utility.sh"

# Gest arguments
archlive_installation_script="${1:-}"
work_directory="${2:-}"
build_script="${3:-}"

test -d "$archlive_installation_script" || \
  error "Archlive installation script must be a directory"
test -n "$work_directory" || error "Work directory must be set"
test -n "$build_script" || error "Build script must be set"

mkdir -p "$work_directory"


# Switch cwd to current script directory
archlive_installation_script="$(realpath "$archlive_installation_script")"
work_directory="$(realpath "$work_directory")"
cd "$(dirname "$0")"


# Create archlive install scipts directory with custom config.
new_installation_script_directory="$work_directory/install_scripts"
cp -rf "$archlive_installation_script" "$new_installation_script_directory"
cp -f ./installation-config "$new_installation_script_directory/config"
rm -rf "$new_installation_script_directory/.git"

# Generates rootfs configure script which extracts installation scripts
build_script_path="$work_directory/$build_script"
label="$(echo $RANDOM | md5sum | head -c 15)"
cat > "$build_script_path" <<EOF
#!/usr/bin/env bash
set -euo pipefail

mkdir /root/archlive-installation-scripts

$(declare -f error)
$(declare -f selfextract)
selfextract /root/archlive-installation-scripts "$label"
exit 0
EOF

inject-directory-in-file "$build_script_path" "$new_installation_script_directory" "$label"
chmod +x "$build_script_path"
