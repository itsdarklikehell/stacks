#!/usr/bin/env bash
set -euo pipefail

# Fix healthchecks in all docker-compose.yaml files under STACKS
# - Uncomments healthcheck blocks
# - Replaces wget with curl
# - Uses correct container port from ports mapping
# - Keeps existing intervals/timeouts

STACKS_ROOT="/media/rizzo/RAIDSTATION/stacks/STACKS"
TMP_DIR=$(mktemp -d)

echo "Scanning for docker-compose files with commented healthchecks..."

find "$STACKS_ROOT" -name "docker-compose.yaml" -type f | while read -r file; do
  # Skip if already has uncommented healthcheck
  if grep -q "^[[:space:]]*healthcheck:" "$file"; then
    continue
  fi

  # Must have commented healthcheck
  if ! grep -q "# healthcheck:" "$file"; then
    continue
  fi

  # Extract container port from the first port mapping after "ports:"
  container_port=$(awk '
    /^[[:space:]]*ports:/ { in_ports=1; next }
    in_ports && /^\s*-\s*[0-9]/ {
      # Match pattern: - HOST:CONTAINER or - CONTAINER (if just one number)
      # We want the container port (second number if colon present, else first)
      if (match($0, /:\s*([0-9]+)/, arr)) {
        print arr[1];
        exit
      } else if (match($0, /-\s*([0-9]+)/, arr)) {
        print arr[1];
        exit
      }
    }
    in_ports && /^[^[:space:]]/ { exit } # stop at next top-level key
    in_ports && /^\s*$/ { next } # skip blank lines
  ' "$file")

  if [ -z "$container_port" ]; then
    echo "WARN: Could not extract port from $file, defaulting to 80"
    container_port=80
  fi

  # Use a temporary file to avoid issues with in-place editing
  tmp1="$TMP_DIR/$(echo "$file" | tr '/' '_').tmp1"

  cp "$file" "$tmp1"

  # Replace the entire commented healthcheck block with the new block
  # We'll use perl with multiline regex to replace from "# healthcheck:" to the line with "#   retries: 3"
  perl -0777 -i -pe '
    $port = $ENV{container_port};
    $new = <<"END_HEALTH";
    healthcheck:
      test: [CMD-SHELL, curl -f http://localhost:${port}/ || exit 1]
      interval: 30s
      timeout: 10s
      start_period: 30s
      retries: 3
END_HEALTH
    s/\s*# healthcheck:.*?#\s+retries: 3/$new/gms;
  ' "$tmp1"

  # If perl succeeded, overwrite original
  if [ $? -eq 0 ]; then
    mv "$tmp1" "$file"
    echo " ✓ Fixed $(realpath --relative-to="$STACKS_ROOT" "$file") [port $container_port]"
  else
    echo " ✗ Failed to process $file"
    rm -f "$tmp1"
  fi
done

rm -rf "$TMP_DIR"
echo "Healthcheck fix complete."
