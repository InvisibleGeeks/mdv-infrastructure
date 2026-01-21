#!/bin/bash

# MDV Infrastructure - MySQL Backup Script

set -e

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.env"

# Configuration
BACKUP_DIR="$SCRIPT_DIR/../backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${DB_DATABASE}_${TIMESTAMP}.sql"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

echo "Starting backup of ${DB_DATABASE}..."

# Run mysqldump inside container
docker-compose -f "$SCRIPT_DIR/../docker-compose.yml" exec -T mysql \
    mysqldump -u "${DB_USERNAME}" -p"${DB_PASSWORD}" "${DB_DATABASE}" > "$BACKUP_FILE"

# Compress backup
gzip "$BACKUP_FILE"

echo "Backup completed: ${BACKUP_FILE}.gz"

# Keep only last 7 backups
cd "$BACKUP_DIR"
ls -t *.sql.gz 2>/dev/null | tail -n +8 | xargs -r rm --

echo "Cleanup completed. Keeping last 7 backups."
