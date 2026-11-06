# Projet 1 : Sauvegarde automatique

Script Bash qui archive un dossier source en `.tar.gz` daté, journalise chaque
étape et supprime les sauvegardes de plus de 7 jours.

## Outils
bash, tar, gzip, find, cron

## Configuration (en haut de backup.sh)
- `SOURCE` : dossier à sauvegarder
- `DEST` : dossier des archives
- `RETENTION_DAYS` : durée de conservation en jours

## Utilisation
chmod +x backup.sh
./backup.sh

## Automatisation (cron)
0 2 * * * /chemin/vers/backup.sh >> ~/backups/cron.log 2>&1

## Restauration
tar -xzf ~/backups/backup_AAAA-MM-JJ_HH-MM-SS.tar.gz -C /dossier/de/destination

## Limites
WSL ne tourne pas en continu : la sauvegarde ne s'exécute que si WSL est actif à l'heure prévue.
