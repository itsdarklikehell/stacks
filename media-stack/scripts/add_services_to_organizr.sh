#!/bin/bash
# Auto-add all services from media-stack/compose.yaml to Organizr dashboard via API
#
# Usage:
#   export ORGANIZR_API_KEY="your_api_key"
#   export ORGANIZR_URL="http://localhost:8086"
#   ./add_services_to_organizr.sh

COMPOSE_FILE="$(dirname "$0")/compose.yaml"

if [[ -z "$ORGANIZR_API_KEY" || -z "$ORGANIZR_URL" ]]; then
  echo "Please set ORGANIZR_API_KEY and ORGANIZR_URL environment variables."
  exit 1
fi

# Extract service names and ports from compose.yaml
grep -E '^[ ]{2,}[a-zA-Z0-9_-]+:' "$COMPOSE_FILE" | \
  grep -vE '^(  services:|  volumes:|  networks:|  secrets:)' | \
  sed 's/^  \([a-zA-Z0-9_-]*\):.*/\1/' | \
  while read svc; do
    # Find the first port mapping for this service
    port=$(awk "/^  $svc:/, /^  [a-zA-Z0-9_-]+:/ {if (/ports:/) p=1; else if (p && /- *[\"']?([0-9]+)[\"']?:[0-9]+/) {gsub(/[^0-9:]/, "", \$0); split(\$0, arr, ":"); print arr[1]; exit}}" "$COMPOSE_FILE")
    # Skip if no port found
    if [[ -z "$port" ]]; then continue; fi
    # Compose the URL for the service (assuming localhost and port mapping)
    url="http://localhost:$port"
    # POST to Organizr API
    curl -s -X POST "$ORGANIZR_URL/api/v2/tab" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $ORGANIZR_API_KEY" \
      -d "{\"name\":\"$svc\",\"url\":\"$url\",\"type\":\"internal\",\"icon\":\"fa-cube\"}"
    echo "Added $svc ($url) to Organizr"
done
