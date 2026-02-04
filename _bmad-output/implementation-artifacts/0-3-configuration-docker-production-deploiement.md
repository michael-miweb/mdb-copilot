# Story 0.3: Configuration Docker production et déploiement backend

Status: done

## Story

As a développeur,
I want configurer le Dockerfile FrankenPHP, docker-compose.prod.yml et deploy.sh,
so that le backend peut être déployé automatiquement sur le serveur OVH.

## Acceptance Criteria

1. **Given** le projet `backend-api/` existant
   **When** le développeur exécute `deploy.sh`
   **Then** l'image Docker est construite avec FrankenPHP + Octane

2. **Given** l'image Docker construite
   **When** elle est pushée
   **Then** l'image est disponible sur `docker-registry.miweb.fr/mdb-copilot-api`

3. **Given** le fichier `docker-compose.prod.yml`
   **When** il est exécuté
   **Then** les services app + MySQL + queue + scheduler sont configurés

4. **Given** la configuration réseau
   **When** Docker démarre
   **Then** le réseau Docker `docker_internal` est utilisé

## Tasks / Subtasks

- [x] Task 1: Créer/Mettre à jour Dockerfile (AC: #1)
  - [x] Base image : FrankenPHP (dunglas/frankenphp:1-php8.4)
  - [x] Installer extensions PHP requises (pdo_mysql, gd, zip, opcache, intl, pcntl)
  - [x] Configurer Octane (ENV OCTANE_SERVER=frankenphp)
  - [x] Copier code application
  - [x] Optimiser pour production (opcache avec JIT, php.ini custom)

- [x] Task 2: Configurer docker-compose.prod.yml (AC: #3, #4)
  - [x] Service `app` : FrankenPHP + Octane avec healthcheck
  - [x] Service `mysql` : MySQL 8.0 avec volume persistant + healthcheck
  - [x] Service `queue` : Laravel queue worker
  - [x] Service `scheduler` : Laravel scheduler (cron loop)
  - [x] Réseau `docker_internal` (external: true)
  - [x] Variables d'environnement via .env.production

- [x] Task 3: Créer script deploy.sh (AC: #1, #2)
  - [x] Build image avec tag versionné (YYYYMMDD-HHMMSS)
  - [x] Push vers registry privé (docker-registry.miweb.fr/mdb-copilot-api)
  - [x] Tag latest en parallèle

- [x] Task 4: Tester le déploiement
  - [x] Build local réussi (vérifié 2026-02-04)
  - [x] Image buildée correctement avec toutes les couches
  - Note: Push vers registry requiert credentials (à faire manuellement)

## Dev Notes

### Dockerfile (Actual Implementation)

```dockerfile
FROM dunglas/frankenphp:1-php8.4

WORKDIR /app

# Extensions PHP (includes redis for future cache support)
RUN install-php-extensions pdo_mysql gd zip opcache intl pcntl redis && \
    apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# Install Composer + dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copy application
COPY --chown=www-data:www-data . /app
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini

# Package discovery + permissions
RUN rm -f bootstrap/cache/packages.php bootstrap/cache/services.php && \
    php artisan package:discover --ansi
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

ENV OCTANE_SERVER=frankenphp
ENV APP_ENV=production

# Port 80 (reverse proxy handles HTTPS termination)
EXPOSE 80

CMD ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=80"]
```

### docker-compose.prod.yml Structure

```yaml
services:
  app:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    networks:
      - docker_internal
    environment:
      - APP_ENV=production
      - DB_HOST=mysql
    depends_on:
      - mysql

  mysql:
    image: mysql:8
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - docker_internal

  queue:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    command: php artisan queue:work
    networks:
      - docker_internal

  scheduler:
    image: docker-registry.miweb.fr/mdb-copilot-api:latest
    command: php artisan schedule:work
    networks:
      - docker_internal

networks:
  docker_internal:
    external: true

volumes:
  mysql_data:
```

### Project Structure Notes
- Existing backend-api/ structure preserved
- FrankenPHP replaces nginx + php-fpm
- Octane provides persistent workers
- Registry: docker-registry.miweb.fr
- **HTTPS:** Handled by external reverse proxy (Traefik/Nginx) — app exposes port 80, SSL termination externe
- **Watchtower:** Auto-deploys new images tagged `:latest` (~5 min)

### References
- [Source: architecture.md#Infrastructure & Deployment]
- [Source: architecture.md#Production]
- [Source: epics.md#Story 0.3]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- Configuration Docker production déjà implémentée et fonctionnelle
- Dockerfile utilise FrankenPHP 1-php8.4 (plus récent que Alpine suggéré)
- Extensions PHP: pdo_mysql, gd, zip, opcache, intl, pcntl installées
- Production optimizations: opcache avec JIT (100M buffer), cache désactivé pour validation
- docker-compose.prod.yml inclut healthchecks pour app et mysql
- deploy.sh avec versioning automatique (timestamp) et tag latest
- .env.production configuré avec les valeurs appropriées (gitignored)
- Build local testé et vérifié (2026-02-04)
- Note: Push vers registry nécessite authentification sur docker-registry.miweb.fr

**Code Review Fixes (2026-02-04):**
- Added redis extension to Dockerfile for future cache support
- Fixed MySQL healthcheck to not expose password in logs (--silent flag)
- Removed session.save_handler from php.ini (Laravel handles via SESSION_DRIVER)
- Updated Dev Notes to match actual implementation
- Added HTTPS/reverse proxy documentation

### File List
- backend-api/Dockerfile (existant, vérifié)
- backend-api/docker-compose.prod.yml (existant, vérifié)
- backend-api/deploy.sh (existant, vérifié)
- backend-api/docker/php/php.ini (existant, vérifié)
- backend-api/.env.production (existant, vérifié)
- backend-api/.dockerignore (existant)
