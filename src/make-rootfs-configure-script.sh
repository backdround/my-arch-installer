#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utility.sh"

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

$(declare -f error)
$(declare -f selfextract)
selfextract /root/installation-script "$label"
exit 0
EOF

inject-directory-in-file "$script_path_to_build" ./archlive-installation-script "$label"
chmod +x "$script_path_to_build"
