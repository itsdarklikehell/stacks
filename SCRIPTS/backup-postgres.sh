#!/usr/bin/env bash
set -euo pipefail

# Backup PostgreSQL Docker volumes
# This script creates compressed tar archives of PostgreSQL data volumes using a temporary Alpine container.
# Modify VOLUMES array to include your PostgreSQL volume names.

BACKUP_DIR="${BACKUP_DIR:-/media/rizzo/RAIDSTATION/BACKUPS/postgres}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

# List of Docker volume names containing PostgreSQL data
VOLUMES=(
  "scanopy_postgres-data"
  # Add other PostgreSQL volume names here, e.g.:
  # "immich-postgres-data"
  # "postgres_data"
)

echo "Starting PostgreSQL volume backup to $BACKUP_DIR"

for VOL in "${VOLUMES[@]}"; do
  if docker volume inspect "$VOL" > /dev/null 2>&1; then
    echo " → Backing up volume: $VOL"
    docker run --rm \
      -v "$VOL:/data" \
      -v "$BACKUP_DIR:/backup" \
      alpine tar czf "/backup/${VOL}-${TIMESTAMP}.tgz" -C /data .
    echo "   ✔ Created: ${VOL}-${TIMESTAMP}.tgz"
  else
    echo " → Volume $VOL not found, skipping"
  fi
done

echo "Backup completed."
