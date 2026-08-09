#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal jq

set -euo pipefail
file="$(cd "$(dirname "$0")" && pwd)/default.nix"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsS -o "$tmp" https://addons.mozilla.org/api/v5/addons/addon/nordvpn-proxy-extension/
new_version="$(jq -r '.current_version.version' "$tmp")"
new_url="$(jq -r '.current_version.file.url' "$tmp")"
new_hash="$(jq -r '.current_version.file.hash | sub("^sha256:"; "")' "$tmp")"

if grep -qF "version = \"$new_version\";" "$file"; then
  echo "nordvpn-proxy: already at $new_version"
  exit 0
fi

sed -i -E \
  -e "s#(version = )\"[^\"]*\";#\1\"$new_version\";#" \
  -e "s#(url = )\"[^\"]*\";#\1\"$new_url\";#" \
  -e "s#(sha256 = )\"[^\"]*\";#\1\"$new_hash\";#" \
  "$file"
echo "nordvpn-proxy: bumped to $new_version"
