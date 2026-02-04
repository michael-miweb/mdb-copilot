# Story 0.2 : Configuration Docker production et déploiement

Status: done

## Story

As a développeur,
I want configurer le Dockerfile FrankenPHP, docker-compose.prod.yml et deploy.sh,
So that le backend peut être déployé automatiquement sur le serveur OVH.

## Acceptance Criteria

1. **Given** le projet `backend-api/` initialisé
   **When** le développeur exécute `deploy.sh`
   **Then** l'image Docker est construite avec FrankenPHP + Octane
   **And** l'image est pushée vers `docker-registry.miweb.fr/mdb-copilot-api`
   **And** `docker-compose.prod.yml` configure app + MySQL + queue + scheduler
   **And** le réseau Docker `docker_internal` est utilisé

## Tasks / Subtasks

- [ ] Task 1 : Créer le Dockerfile avec FrankenPHP + Octane (AC: #1)
  - [ ] 1.1 Créer `backend-api/Dockerfile` basé sur l'image Alpine FrankenPHP
  - [ ] 1.2 Installer les extensions PHP nécessaires : pdo_mysql, gd, zip, opcache, intl
  - [ ] 1.3 Activer l'extension Octane dans le Dockerfile
  - [ ] 1.4 Configurer les variables d'environnement : `OCTANE_SERVER=frankenphp`, `APP_ENV=production`
  - [ ] 1.5 Définir le WORKDIR `/app` et copier le code Laravel
  - [ ] 1.6 Exécuter `composer install --no-dev --optimize-autoloader`
  - [ ] 1.7 Configurer les permissions : `storage/` et `bootstrap/cache/` en 775
  - [ ] 1.8 Définir le CMD : `php artisan octane:frankenphp --host=0.0.0.0 --port=80`

- [ ] Task 2 : Configurer docker-compose.prod.yml (AC: #1)
  - [ ] 2.1 Créer `backend-api/docker-compose.prod.yml`
  - [ ] 2.2 Service `app` : image `docker-registry.miweb.fr/mdb-copilot-api:latest`, port 80, réseau `docker_internal`
  - [ ] 2.3 Service `mysql` : image `mysql:8.0`, volume persistant, variables d'environnement DB, réseau `docker_internal`
  - [ ] 2.4 Service `queue` : même image que app, commande `php artisan queue:work --sleep=3 --tries=3 --max-time=3600`
  - [ ] 2.5 Service `scheduler` : même image que app, commande `sh -c "while true; do php artisan schedule:run; sleep 60; done"`
  - [ ] 2.6 Définir le réseau externe `docker_internal` avec `external: true`
  - [ ] 2.7 Configurer les volumes persistants : `mysql-data` pour la base de données
  - [ ] 2.8 Ajouter les health checks pour le service app

- [ ] Task 3 : Créer le fichier docker/php/php.ini (AC: #1)
  - [ ] 3.1 Créer `backend-api/docker/php/php.ini`
  - [ ] 3.2 Configurer opcache : `opcache.enable=1`, `opcache.memory_consumption=256`, `opcache.max_accelerated_files=20000`
  - [ ] 3.3 Activer JIT : `opcache.jit=tracing`, `opcache.jit_buffer_size=100M`
  - [ ] 3.4 Configurer timezone : `date.timezone=Europe/Paris`
  - [ ] 3.5 Ajuster memory_limit : `memory_limit=512M`
  - [ ] 3.6 Configurer upload : `upload_max_filesize=20M`, `post_max_size=20M`

- [ ] Task 4 : Créer le script deploy.sh (AC: #1)
  - [ ] 4.1 Créer `backend-api/deploy.sh` avec shebang `#!/bin/bash`
  - [ ] 4.2 Définir les variables : `IMAGE_NAME="docker-registry.miweb.fr/mdb-copilot-api"`, `VERSION=$(date +%Y%m%d-%H%M%S)`
  - [ ] 4.3 Étape 1 : Build de l'image avec multi-tag : `docker build -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest .`
  - [ ] 4.4 Étape 2 : Push vers le registry : `docker push ${IMAGE_NAME}:${VERSION}` et `docker push ${IMAGE_NAME}:latest`
  - [ ] 4.5 Ajouter des messages de log clairs à chaque étape
  - [ ] 4.6 Rendre le script exécutable : `chmod +x deploy.sh`
  - [ ] 4.7 Ajouter une vérification que l'utilisateur est connecté au registry Docker

- [ ] Task 5 : Configurer .env.production (AC: #1)
  - [ ] 5.1 Créer `backend-api/.env.production` avec les variables production
  - [ ] 5.2 Configurer : `APP_ENV=production`, `APP_DEBUG=false`, `APP_URL=https://api.mdbcopilot.miweb.fr`
  - [ ] 5.3 Variables DB : `DB_HOST=mysql`, `DB_DATABASE=mdb_copilot_prod`, `DB_USERNAME=mdb_user`, `DB_PASSWORD=` (à renseigner)
  - [ ] 5.4 Sanctum : `SANCTUM_STATEFUL_DOMAINS=mdbcopilot.miweb.fr`
  - [ ] 5.5 Octane : `OCTANE_SERVER=frankenphp`
  - [ ] 5.6 Cache : `CACHE_DRIVER=database`, `QUEUE_CONNECTION=database`
  - [ ] 5.7 Ajouter `.env.production` au `.gitignore` (sécurité)

- [ ] Task 6 : Documentation déploiement (AC: #1)
  - [ ] 6.1 Créer `backend-api/DEPLOY.md` avec les instructions de déploiement
  - [ ] 6.2 Documenter les prérequis : accès au registry, réseau `docker_internal` créé sur OVH
  - [ ] 6.3 Documenter la commande de build : `./deploy.sh`
  - [ ] 6.4 Documenter le déploiement sur OVH : `docker compose -f docker-compose.prod.yml up -d`
  - [ ] 6.5 Documenter Watchtower : auto-pull des images `latest` toutes les 5 minutes
  - [ ] 6.6 Documenter les commandes de debug : logs, exec, restart

- [ ] Task 7 : Validation finale (AC: #1)
  - [ ] 7.1 Vérifier la structure : `backend-api/` contient `Dockerfile`, `docker-compose.prod.yml`, `deploy.sh`, `docker/php/php.ini`, `DEPLOY.md`
  - [ ] 7.2 Tester le build local : `docker build -t mdb-copilot-api:test .`
  - [ ] 7.3 Tester le lancement local : `docker run -p 8080:80 mdb-copilot-api:test`
  - [ ] 7.4 Vérifier que l'app répond sur `http://localhost:8080`
  - [ ] 7.5 Commit : `git add . && git commit -m "feat: configure Docker production with FrankenPHP + Octane and deploy script"`

## Dev Notes

### Architecture & Contraintes

- **Production Stack** : FrankenPHP + Octane pour des performances optimales avec moins de consommation mémoire comparé à PHP-FPM [Source: architecture.md#Infrastructure & Deployment]
- **Registry privé** : `docker-registry.miweb.fr` — authentification requise, hébergé sur l'infra OVH [Source: architecture.md#Production]
- **Réseau Docker** : `docker_internal` — réseau bridge existant sur le serveur OVH, permet la communication inter-containers tout en isolant du réseau public [Source: epics.md#Story 0.2]
- **Multi-services** : app + MySQL + queue worker + scheduler dans le même stack docker-compose pour orchestration complète [Source: architecture.md#Infrastructure & Deployment]
- **Watchtower** : outil de surveillance des images Docker qui redémarre automatiquement les containers quand une nouvelle version `latest` est disponible sur le registry [Source: architecture.md#Infrastructure & Deployment]

### Versions techniques confirmées

- **FrankenPHP** : latest stable (basé sur Caddy) — image officielle Alpine
- **Laravel Octane** : v2.x (inclus via `composer require laravel/octane`)
- **MySQL** : 8.0.x
- **PHP** : 8.2+ requis par Laravel 12
- **Docker Compose** : v2.x (syntaxe moderne)

### Configuration FrankenPHP + Octane

FrankenPHP est un serveur d'application PHP moderne basé sur Caddy qui intègre nativement le support des workers persistants. Octane utilise cette fonctionnalité pour maintenir l'application Laravel en mémoire.

**Avantages FrankenPHP + Octane :**
- Pas de redémarrage PHP à chaque requête (application Laravel persistante)
- HTTP/2 et HTTP/3 natifs via Caddy
- Compression automatique
- HTTPS auto via Let's Encrypt (si configuré)
- ~50% moins de mémoire que PHP-FPM + Nginx

**Dockerfile pattern :**

```dockerfile
FROM dunglas/frankenphp:latest-php8.2-alpine

WORKDIR /app

# Extensions PHP
RUN install-php-extensions pdo_mysql gd zip opcache intl

# Copie des fichiers
COPY --chown=www-data:www-data . /app

# Composer install
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Config Octane
ENV OCTANE_SERVER=frankenphp

# Copie php.ini custom
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini

CMD ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=80"]
```

### docker-compose.prod.yml — structure

```yaml
version: '3.8'

services:
  app:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    container_name: mdb-copilot-app
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      - APP_ENV=production
      - APP_DEBUG=false
    env_file:
      - .env.production
    networks:
      - docker_internal
    depends_on:
      - mysql
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  mysql:
    image: mysql:8.0
    container_name: mdb-copilot-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USERNAME}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - docker_internal

  queue:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    container_name: mdb-copilot-queue
    restart: unless-stopped
    command: php artisan queue:work --sleep=3 --tries=3 --max-time=3600
    env_file:
      - .env.production
    networks:
      - docker_internal
    depends_on:
      - mysql

  scheduler:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    container_name: mdb-copilot-scheduler
    restart: unless-stopped
    command: sh -c "while true; do php artisan schedule:run; sleep 60; done"
    env_file:
      - .env.production
    networks:
      - docker_internal
    depends_on:
      - mysql

networks:
  docker_internal:
    external: true

volumes:
  mysql-data:
    driver: local
```

### deploy.sh — workflow

Le script `deploy.sh` automatise le processus de build et push :

1. **Build** : construit l'image avec deux tags (version horodatée + latest)
2. **Push** : envoie les deux tags vers le registry privé
3. **Watchtower** : détecte automatiquement la nouvelle image `latest` et redémarre les containers sur OVH

```bash
#!/bin/bash
set -e

IMAGE_NAME="docker-registry.miweb.fr/mdb-copilot-api"
VERSION=$(date +%Y%m%d-%H%M%S)

echo "🏗️  Building Docker image..."
docker build -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest .

echo "📦 Pushing to registry..."
docker push ${IMAGE_NAME}:${VERSION}
docker push ${IMAGE_NAME}:latest

echo "✅ Deploy completed: ${IMAGE_NAME}:${VERSION}"
echo "⏳ Watchtower will auto-deploy on OVH server in ~5 minutes"
```

### Réseau docker_internal

Le réseau `docker_internal` doit être créé manuellement sur le serveur OVH avant le premier déploiement :

```bash
docker network create docker_internal
```

Ce réseau permet :
- Communication inter-containers (app ↔ mysql, queue ↔ mysql, etc.)
- Isolation du réseau public (seul le service `app` expose le port 80)
- Réutilisation entre plusieurs projets sur le même serveur OVH

### php.ini production

Configuration optimale pour Laravel + Octane :

```ini
; Opcache
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000
opcache.validate_timestamps=0
opcache.save_comments=1

; JIT
opcache.jit=tracing
opcache.jit_buffer_size=100M

; General
memory_limit=512M
upload_max_filesize=20M
post_max_size=20M
max_execution_time=60

; Timezone
date.timezone=Europe/Paris

; Sessions (Octane doesn't use file sessions but keep for safety)
session.save_handler=files
session.gc_maxlifetime=1440
```

### Project Structure Notes

Structure cible après cette story :

```
backend-api/
├── Dockerfile                      # Image FrankenPHP + Octane
├── docker-compose.prod.yml         # Orchestration production
├── deploy.sh                       # Script de build + push
├── DEPLOY.md                       # Documentation déploiement
├── docker/
│   └── php/
│       └── php.ini                 # Config PHP production
├── .env.production                 # Variables d'environnement production (ignoré Git)
├── .env.example
├── compose.yaml                    # Sail dev (déjà existant depuis Story 0.1)
└── ...
```

- Le `Dockerfile` et `docker-compose.prod.yml` sont séparés de la config Sail dev
- Sail (`compose.yaml`) reste utilisé pour le développement local
- La production utilise FrankenPHP + Octane au lieu de PHP-FPM + Nginx

### References

- [Source: architecture.md#Infrastructure & Deployment] — Configuration Docker production complète
- [Source: architecture.md#Production] — Stack FrankenPHP + Octane, registry privé, Watchtower
- [Source: epics.md#Story 0.2] — Acceptance criteria BDD
- [Source: architecture.md#Environnement de développement] — Séparation Sail dev / Docker prod

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- FrankenPHP `latest-php8.2-alpine` incompatible avec composer.lock (Symfony v8 requiert PHP 8.4+)
- FrankenPHP `latest` (Debian) a PHP 8.5 — cause erreur `SIGINT undefined` dans Octane (extension pcntl manquante)
- FrankenPHP `1-php8.4` (Debian) — même erreur SIGINT → corrigé en ajoutant `pcntl` aux extensions
- `laravel/pail` (dev-only) causait erreur au `package:discover` en production → résolu en supprimant les caches bootstrap avant discover
- `.dockerignore` créé pour éviter d'envoyer vendor/ et fichiers sensibles au daemon
- `composer dump-autoload --no-dev` supprimé car déclenche les scripts post-autoload qui cherchent des packages dev

### Completion Notes List

- ✅ Dockerfile basé sur `dunglas/frankenphp:1-php8.4` avec extensions pdo_mysql, gd, zip, opcache, intl, pcntl
- ✅ docker-compose.prod.yml avec services app, mysql, queue, scheduler + réseau docker_internal + healthchecks
- ✅ docker/php/php.ini avec opcache, JIT, timezone Europe/Paris, memory_limit 512M
- ✅ deploy.sh avec build multi-tag + push registry + vérification auth
- ✅ .env.production avec config production complète
- ✅ DEPLOY.md avec documentation déploiement
- ✅ .dockerignore pour optimiser le build
- ✅ Laravel Octane v2.13.5 installé
- ✅ Build Docker : succès, image teste OK (HTTP 200 + /api/health OK)

### File List

- `backend-api/Dockerfile` — NEW
- `backend-api/docker-compose.prod.yml` — NEW
- `backend-api/deploy.sh` — NEW (executable)
- `backend-api/docker/php/php.ini` — NEW
- `backend-api/.env.production` — NEW (gitignored)
- `backend-api/DEPLOY.md` — NEW
- `backend-api/.dockerignore` — NEW
- `backend-api/composer.json` — MODIFIED (ajout laravel/octane)
- `backend-api/composer.lock` — MODIFIED (laravel/octane + deps)
- `.gitignore` — MODIFIED (ajout .env.production)
