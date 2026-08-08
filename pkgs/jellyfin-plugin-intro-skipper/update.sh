#!/usr/bin/env bash
# Tags look like "<branch>/v<version>" (e.g. 10.11/v1.10.11.21). Strip the
# branch prefix, bump version + src (nix-update also re-hashes pnpmDeps), then
# regenerate the nuget deps.json in place.
set -euo pipefail
attr="${1:-${UPDATE_NIX_ATTR_PATH:-jellyfin-plugin-intro-skipper}}"
nix-update --flake --version-regex '^[^/]+/v(.*)$' "$attr"
nix run ".#$attr.fetch-deps"
