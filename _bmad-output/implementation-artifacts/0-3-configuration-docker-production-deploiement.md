# Story 0.3: Configuration Docker production et déploiement backend

Status: ready-for-dev

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

- [ ] Task 1: Créer/Mettre à jour Dockerfile (AC: #1)
  - [ ] Base image : FrankenPHP Alpine
  - [ ] Installer extensions PHP requises
  - [ ] Configurer Octane
  - [ ] Copier code application
  - [ ] Optimiser pour production (opcache, etc.)

- [ ] Task 2: Configurer docker-compose.prod.yml (AC: #3, #4)
  - [ ] Service `app` : FrankenPHP + Octane
  - [ ] Service `mysql` : MySQL 8.x avec volume persistant
  - [ ] Service `queue` : Laravel queue worker
  - [ ] Service `scheduler` : Laravel scheduler
  - [ ] Réseau `docker_internal`
  - [ ] Variables d'environnement de production

- [ ] Task 3: Créer script deploy.sh (AC: #1, #2)
  - [ ] Build image avec tag versionné
  - [ ] Push vers registry privé
  - [ ] Support multi-architecture (amd64)

- [ ] Task 4: Tester le déploiement
  - [ ] Build local réussi
  - [ ] Push vers registry
  - [ ] Vérifier que l'image démarre correctement

## Dev Notes

### Dockerfile Example

```dockerfile
FROM dunglas/frankenphp:latest-php8.3-alpine

# Install PHP extensions
RUN install-php-extensions \
    pdo_mysql \
    redis \
    pcntl \
    opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy application
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Configure Octane
ENV OCTANE_SERVER=frankenphp

# Expose port
EXPOSE 8000

CMD ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=8000"]
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

### References
- [Source: architecture.md#Infrastructure & Deployment]
- [Source: architecture.md#Production]
- [Source: epics.md#Story 0.3]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
