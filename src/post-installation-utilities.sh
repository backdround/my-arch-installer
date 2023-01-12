#!/usr/bin/env bash
set -euo pipefail

error() {
  echo "$@" >&2
  return 1
}

# download latest deploy-configs
download-deploy-configs() {
  PATH_TO_DOWNLOAD="${1:-}"
  if [[ -z "$PATH_TO_DOWNLOAD" ]]; then
    error "Path to download deploy-configs isn't set"
  fi

  # Changes work directory
  TEMP_DIRECTORY="$(mktemp -d)"
  cd "$TEMP_DIRECTORY"

  # Gets binary urs
  curl -o ./deploy-configs-release.json \
    https://api.github.com/repos/backdround/deploy-configs/releases/latest
  echo ".assets[] \
    | select(.name | match(\"deploy-configs-linux-amd64-.*[.]tar[.]gz\")) \
    | .browser_download_url" \
      > ./query.jq
  BINARY_URL="$(jq -r -f ./query.jq ./deploy-configs-release.json)"

  # Gets binary
  curl -L -o ./deploy-configs.tar.gz "$BINARY_URL"
  tar -xvf ./deploy-configs.tar.gz

  # Deploy binary
  mkdir -p "$PATH_TO_DOWNLOAD"
  mv -f ./deploy-configs "$PATH_TO_DOWNLOAD"

  # Cleans up
  cd - > /dev/null
  rm -rf "$TEMP_DIRECTORY"
}
