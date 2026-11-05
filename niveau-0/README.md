# Niveau 0 : Fondations

## Objectif
Mettre en place un environnement de travail DevOps propre et sécurisé sous WSL2.

## Ce qui a été réalisé
- **WSL2** : systemd activé, ressources limitées via `.wslconfig` (RAM, swap)
- **Git** : configuration globale, authentification SSH vers GitHub (clé ed25519 avec passphrase)
- **SSH durci** : authentification par clés uniquement, root désactivé, `MaxAuthTries 3`
- **Pare-feu ufw** : politique deny en entrée, seul le port 22 ouvert
- **fail2ban** : jail `sshd` active (3 essais, bannissement 1 h)

## Configuration clé
```ini
# /etc/ssh/sshd_config.d/99-hardening.conf
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
MaxAuthTries 3
```

```ini
# /etc/fail2ban/jail.local
[sshd]
enabled = true
backend = systemd
maxretry = 3
bantime = 1h
findtime = 10m
```

## Vérifications
Voir [verification.txt](verification.txt) : état de systemd, ufw et fail2ban.

## Ce que j'ai appris
- La différence entre clé publique et privée, et pourquoi le mot de passe SSH est désactivé
- `backend = systemd` pour fail2ban sur Debian récent (logs dans journald)
- WSL et VM n'ont pas le même réseau (WSL2 est sur un réseau virtuel interne)
- HTTPS demande un token, SSH évite ce problème

## Limites
Sous WSL2, la machine n'est pas exposée au réseau : c'est un exercice de bonnes pratiques, à reproduire sur un vrai serveur.
