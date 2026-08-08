#!/usr/bin/env bash
# Discover the latest @z_ai/mcp-server release from the npm registry, then bump
# the package (nix-update re-fetches src and auto-fixes npmDepsHash). curl and
# jq are pulled from nix, so the script only needs nix + nix-update on PATH.
set -euo pipefail
attr="${1:-${UPDATE_NIX_ATTR_PATH:-z-ai-vision-mcp-server}}"
latest="$(nix shell nixpkgs#curl nixpkgs#jq -c sh -c 'curl -fsS https://registry.npmjs.org/@z_ai/mcp-server/latest | jq -r .version')"
exec nix-update --flake --version="$latest" "$attr"
