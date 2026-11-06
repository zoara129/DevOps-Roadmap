#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
SOURCE="$HOME/roadmap-devops"
DEST="$HOME/backups"
RETENTION_DAYS=7
LOG_FILE="$DEST/backup.log"

# --- Préparation ---
mkdir -p "$DEST"
DATE=$(date +%F_%H-%M-%S)
ARCHIVE="$DEST/backup_${DATE}.tar.gz"

log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG_FILE"
}

# --- Vérifications ---
if [ ! -d "$SOURCE" ]; then
    log "ERREUR : le dossier source $SOURCE n'existe pas"
    exit 1
fi

# --- Sauvegarde ---
log "Début de la sauvegarde de $SOURCE"
if tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"; then
    SIZE=$(du -h "$ARCHIVE" | cut -f1)
    log "Succès : $ARCHIVE ($SIZE)"
else
    log "ERREUR : échec de la création de l'archive"
    exit 1
fi

# --- Rotation ---
DELETED=$(find "$DEST" -name "backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -print -delete | wc -l)
log "Rotation : $DELETED ancienne(s) sauvegarde(s) supprimée(s) (> $RETENTION_DAYS jours)"
