{
  pkgs,
  serviceName,
  port,
  urlBase,
  apiKeyPath,
}:
pkgs.writeShellScript "${serviceName}-wait-for-api" ''
  set -eu

  if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "$CREDENTIALS_DIRECTORY/api_key" ]; then
    API_KEY=$(cat "$CREDENTIALS_DIRECTORY/api_key")
    echo "Using API key from CREDENTIALS_DIRECTORY"
  else
    API_KEY=$(cat ${apiKeyPath})
    echo "Using API key from ${apiKeyPath}"
  fi

  FULL_URL="http://127.0.0.1:${toString port}${urlBase}/api/system/status"
  echo "Waiting for Bazarr API at $FULL_URL..."

  for i in {1..90}; do
    if ${pkgs.curl}/bin/curl -s -f -H "X-API-KEY: $API_KEY" "$FULL_URL" >/dev/null 2>&1; then
      echo "Bazarr API is available"
      sleep 3
      exit 0
    fi
    echo "Waiting for Bazarr API... ($i/90)"
    sleep 1
  done

  echo "Bazarr API not available after 90 seconds" >&2
  exit 1
''
