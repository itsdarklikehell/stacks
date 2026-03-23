#!/usr/bin/env bash
set -euo pipefail

# Comprehensive PostgreSQL Docker volume backup
# Backs up all PostgreSQL data volumes from all stacks.

BACKUP_DIR="${BACKUP_DIR:-/media/rizzo/RAIDSTATION/BACKUPS/postgres}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

# Auto-discover PostgreSQL volumes by inspecting Docker volumes with common naming patterns
# This finds volumes containing postgres data (named like *postgres*, *pgsql*, *db* etc.)
echo "Discovering PostgreSQL volumes..."

# Known PostgreSQL volume names (add as you discover more)
POSTGRES_VOLUMES=(
  "scanopy_postgres-data"
  "immich-server_database"
  "litellm_db_data"
  # Add more as needed
)

# Also auto-discover volumes that look like PostgreSQL data directories
# by checking for PG_VERSION file inside the volume
echo "Scanning for PostgreSQL data volumes..."
for VOL in $(docker volume ls -q); do
  # Skip if already in list
  if printf "%s\n" "${POSTGRES_VOLUMES[@]}" | grep -qx "$VOL"; then
    continue
  fi
  # Heuristic: volume name contains 'postgres' or 'pgsql' or ends with '_data' and might be PG
  if [[ "$VOL" == *postgres* ]] || [[ "$VOL" == *pgsql* ]] || [[ "$VOL" == *_db* ]]; then
    # Quick check: try to read PG_VERSION from the volume (requires a container)
    if docker run --rm -v "$VOL:/data" alpine sh -c 'test -f /data/PG_VERSION' 2>/dev/null; then
      echo "Discovered PostgreSQL volume: $VOL"
      POSTGRES_VOLUMES+=("$VOL")
    fi
  fi
done

echo ""
echo "Starting PostgreSQL volume backup to $BACKUP_DIR"
echo "Volumes to backup: ${#POSTGRES_VOLUMES[@]}"
echo ""

for VOL in "${POSTGRES_VOLUMES[@]}"; do
  if docker volume inspect "$VOL" > /dev/null 2>&1; then
    echo " → Backing up volume: $VOL"
    BACKUP_FILE="${BACKUP_DIR}/${VOL}-${TIMESTAMP}.tgz"
    docker run --rm \
      -v "$VOL:/data:ro" \
      -v "$BACKUP_DIR:/backup" \
      alpine tar czf "/backup/$(basename "$BACKUP_FILE")" -C /data .
    echo "   ✔ Created: $(basename "$BACKUP_FILE")"
  else
    echo " → Volume $VOL not found, skipping"
  fi
done

echo ""
echo "Backup completed."
echo "Total backups in $BACKUP_DIR: $(ls -1 "$BACKUP_DIR"/*.tgz 2>/dev/null | wc -l)"
