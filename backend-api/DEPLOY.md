# Déploiement MDB Copilot API

## Prérequis

- Docker installé localement (pour le build)
- Accès au registry : `docker login docker-registry.miweb.fr`
- Réseau Docker `docker_internal` créé sur le serveur OVH :
  ```bash
  docker network create docker_internal
  ```

## Build et push

```bash
cd backend-api
./deploy.sh
```

Le script :
1. Vérifie la connexion au registry
2. Build l'image avec FrankenPHP + Octane
3. Push deux tags : version horodatée + `latest`

## Déploiement sur OVH

### Premier déploiement

```bash
# Sur le serveur OVH
cd /opt/mdb-copilot

# Copier le template d'environnement depuis le repo et remplir les secrets
# Renseigner : APP_KEY, DB_PASSWORD, DB_ROOT_PASSWORD

# Générer la clé d'application
docker run --rm docker-registry.miweb.fr/mdb-copilot-api:latest php artisan key:generate --show

# Lancer les services
docker compose -f docker-compose.prod.yml up -d

# Exécuter les migrations
docker exec mdb-copilot-app php artisan migrate --force
```

### Mises à jour suivantes

Watchtower surveille automatiquement l'image `latest` et redéploie toutes les ~5 minutes.

Pour forcer un redéploiement immédiat :
```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

## Commandes de debug

```bash
# Logs de l'application
docker logs -f mdb-copilot-app

# Logs du queue worker
docker logs -f mdb-copilot-queue

# Shell dans le container
docker exec -it mdb-copilot-app sh

# Exécuter une commande Artisan
docker exec mdb-copilot-app php artisan <commande>

# Redémarrer un service
docker compose -f docker-compose.prod.yml restart app

# Status des services
docker compose -f docker-compose.prod.yml ps
```

## Architecture des services

| Service | Image | Rôle |
|---------|-------|------|
| `app` | mdb-copilot-api | FrankenPHP + Octane (HTTP) |
| `mysql` | mysql:8.0 | Base de données |
| `queue` | mdb-copilot-api | Queue worker |
| `scheduler` | mdb-copilot-api | Cron scheduler |

Tous les services sont sur le réseau `docker_internal` (bridge externe).
Seul le service `app` expose le port 80.
