#!/usr/bin/env bash
# Bump version + src, then regenerate the nuget deps.json in place.
set -euo pipefail
attr="${1:-${UPDATE_NIX_ATTR_PATH:-jellyfin-plugin-file-transformation}}"
nix-update --flake "$attr"
nix run ".#$attr.fetch-deps"
