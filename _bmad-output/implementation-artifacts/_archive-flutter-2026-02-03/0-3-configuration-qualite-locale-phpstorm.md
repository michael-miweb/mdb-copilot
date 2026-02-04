# Story 0.3 : Configuration qualité locale dans PHPStorm

Status: done

## Story

As a développeur,
I want configurer PHPStorm pour exécuter automatiquement les outils de qualité de code (lint, analyse statique, tests),
So that la qualité du code est garantie localement sans dépendre d'un pipeline CI/CD distant.

## Acceptance Criteria

1. **Given** PHPStorm ouvert sur le projet `backend-api/`
   **When** le développeur sauvegarde un fichier PHP ou exécute l'inspection
   **Then** PHPStan (niveau max) est configuré comme inspection externe dans PHPStorm
   **And** Laravel Pint est configuré comme formateur de code (File Watcher ou on-save)
   **And** PHPUnit est configuré comme framework de test avec l'interpréteur Sail (Docker)

2. **Given** PHPStorm ouvert sur le projet `mobile-app/`
   **When** le développeur travaille sur le code Flutter
   **Then** `very_good analyze` est configuré comme inspection externe
   **And** `very_good test` est exécutable depuis la configuration Run/Debug
   **And** le Dart SDK est correctement référencé

3. **Given** les outils de qualité configurés
   **When** le développeur lance une vérification complète (via un Run Configuration dédiée)
   **Then** PHPStan, Pint, PHPUnit (backend) et very_good analyze, very_good test (frontend) s'exécutent
   **And** les résultats sont affichés dans le panneau d'inspection PHPStorm
   **And** les erreurs sont navigables directement vers le code source

## Tasks / Subtasks

- [ ] Task 1 : Configurer PHPStan dans PHPStorm (AC: #1)
  - [ ] 1.1 Installer PHPStan : `cd backend-api && composer require --dev phpstan/phpstan larastan/larastan`
  - [ ] 1.2 Créer `backend-api/phpstan.neon` avec niveau max, paths `app/`, `database/`, `tests/`
  - [ ] 1.3 Configurer PHPStorm : Settings → PHP → Quality Tools → PHPStan → pointer vers `vendor/bin/phpstan`
  - [ ] 1.4 Activer l'inspection PHPStan dans Settings → Editor → Inspections → PHP → Quality Tools
  - [ ] 1.5 Tester : ouvrir un fichier PHP, vérifier que les erreurs PHPStan s'affichent inline

- [ ] Task 2 : Configurer Laravel Pint dans PHPStorm (AC: #1)
  - [ ] 2.1 Laravel Pint est inclus par défaut avec Laravel 12, vérifier sa présence
  - [ ] 2.2 Configurer PHPStorm : Settings → PHP → Quality Tools → Laravel Pint → pointer vers `vendor/bin/pint`
  - [ ] 2.3 Configurer le formatage on-save : Settings → Tools → Actions on Save → cocher Reformat Code avec Pint
  - [ ] 2.4 Alternative : créer un File Watcher pour Pint (Settings → Tools → File Watchers)
  - [ ] 2.5 Tester : modifier un fichier PHP, sauvegarder, vérifier le formatage automatique

- [ ] Task 3 : Configurer PHPUnit dans PHPStorm avec Sail (AC: #1)
  - [ ] 3.1 Configurer l'interpréteur PHP distant via Docker Compose (Sail) : Settings → PHP → CLI Interpreter → ajouter Docker Compose
  - [ ] 3.2 Sélectionner le service `laravel.test` du `docker-compose.yml` Sail
  - [ ] 3.3 Configurer PHPUnit : Settings → PHP → Test Frameworks → PHPUnit by Remote Interpreter
  - [ ] 3.4 Créer `backend-api/.env.testing` avec `DB_DATABASE=:memory:` (SQLite), `APP_ENV=testing`
  - [ ] 3.5 Créer un test exemple : `tests/Feature/HealthCheckTest.php` qui vérifie `/api/health` retourne 200
  - [ ] 3.6 Tester : lancer le test depuis PHPStorm (bouton play), vérifier l'exécution via Sail

- [ ] Task 4 : Configurer Very Good CLI dans PHPStorm (AC: #2)
  - [ ] 4.1 Vérifier que le plugin Flutter/Dart est installé dans PHPStorm
  - [ ] 4.2 Configurer le Dart SDK dans Settings → Languages & Frameworks → Dart
  - [ ] 4.3 Vérifier que `mobile-app/analysis_options.yaml` inclut `package:very_good_analysis/analysis_options.yaml`
  - [ ] 4.4 Créer une Run Configuration "Very Good Analyze" : External Tool → `very_good analyze mobile-app`
  - [ ] 4.5 Créer une Run Configuration "Very Good Test" : External Tool → `very_good test mobile-app --coverage`
  - [ ] 4.6 Tester : exécuter les configurations, vérifier les résultats dans la console PHPStorm

- [ ] Task 5 : Créer une Run Configuration "Full Quality Check" (AC: #3)
  - [ ] 5.1 Créer un Compound Run Configuration dans PHPStorm regroupant : PHPStan, PHPUnit, Very Good Analyze, Very Good Test
  - [ ] 5.2 Ou créer un script shell `scripts/quality-check.sh` exécutable depuis PHPStorm
  - [ ] 5.3 Tester : lancer la vérification complète, vérifier que tous les outils s'exécutent
  - [ ] 5.4 Documenter la procédure dans `CLAUDE.md`

- [ ] Task 6 : Configurer PHPStan (fichier de config) (AC: #1)
  - [ ] 6.1 Créer `backend-api/phpstan.neon` avec les includes Larastan
  - [ ] 6.2 Configurer niveau max, paths `app/`, `database/`, `tests/`
  - [ ] 6.3 Configurer les exclusions : `bootstrap/cache/`, `storage/`
  - [ ] 6.4 Tester en local : `./vendor/bin/phpstan analyse`

- [ ] Task 7 : Validation finale (AC: #1, #2, #3)
  - [ ] 7.1 Vérifier que PHPStan affiche les erreurs inline dans les fichiers PHP
  - [ ] 7.2 Vérifier que Pint formate automatiquement à la sauvegarde
  - [ ] 7.3 Vérifier que PHPUnit s'exécute via Sail depuis PHPStorm
  - [ ] 7.4 Vérifier que Very Good Analyze et Test fonctionnent via les Run Configurations
  - [ ] 7.5 Vérifier que le Compound Run Configuration exécute tous les checks
  - [ ] 7.6 Commit final : `git add . && git commit -m "devops: configure PHPStorm quality tools (PHPStan, Pint, PHPUnit, Very Good CLI)"`

## Dev Notes

### Architecture & Contraintes

- **Tout en local** : pas de CI/CD distant, toute la qualité de code est gérée via PHPStorm
- **PHPStan niveau max** : strictesse maximale, Larastan pour le support Laravel [Source: architecture.md]
- **Laravel Pint** : formateur PSR-12 natif Laravel, intégré on-save dans PHPStorm
- **PHPUnit via Sail** : les tests backend s'exécutent dans le conteneur Docker Sail
- **Very Good CLI pour Flutter** : `very_good analyze` et `very_good test` comme standards du starter VGV

### Versions techniques confirmées

- **PHPStorm** : version courante avec plugins Flutter/Dart
- **PHP** : 8.2 (via Sail/Docker)
- **Flutter** : 3.38.x
- **Very Good CLI** : latest via `dart pub global activate very_good_cli`
- **PHPStan** : v1.x (latest stable) + Larastan
- **Laravel Pint** : inclus avec Laravel 12
- **PHPUnit** : v11.x (inclus avec Laravel 12)

### phpstan.neon — configuration

```neon
includes:
    - ./vendor/larastan/larastan/extension.neon

parameters:
    level: max
    paths:
        - app
        - database
        - tests

    excludePaths:
        - bootstrap/cache
        - storage
        - node_modules

    checkMissingIterableValueType: false
    checkGenericClassInNonGenericObjectType: false
```

### PHPUnit coverage — configuration

Dans `backend-api/phpunit.xml` :

```xml
<coverage>
    <report>
        <html outputDirectory="coverage/html"/>
        <clover outputFile="coverage/clover.xml"/>
    </report>
    <include>
        <directory suffix=".php">./app</directory>
    </include>
    <exclude>
        <directory>./app/Exceptions</directory>
        <directory>./app/Console</directory>
    </exclude>
</coverage>
```

### Very Good CLI — commandes

| Commande | Équivalent Flutter standard | Avantage VGV |
|----------|---------------------------|-------------|
| `very_good analyze` | `flutter analyze` | Lint strictes VGV Analysis incluses |
| `very_good test --coverage` | `flutter test --coverage` | Format coverage automatique |
| `very_good test --min-coverage=80` | (manuel) | Fail automatique si < 80% |

### Project Structure Notes

Structure cible après cette story :

```
backend-api/
├── phpstan.neon                    # Config PHPStan niveau max
├── phpunit.xml                     # Config PHPUnit avec coverage
├── .env.testing                    # Variables d'environnement tests
└── tests/
    ├── Feature/
    │   └── HealthCheckTest.php     # Test exemple
    └── Unit/

mobile-app/
├── analysis_options.yaml           # Déjà présent (VGV)
└── test/                           # Déjà présent (VGV)

scripts/
└── quality-check.sh               # Script qualité globale (optionnel)

CLAUDE.md                           # Mise à jour avec procédures qualité locale
```

- Les configs PHPStan et PHPUnit sont à la racine de `backend-api/`
- Les tests Flutter sont déjà générés par Very Good CLI dans Story 0.1
- `CLAUDE.md` documente les procédures de qualité locale pour les agents IA
- Pas de `.github/workflows/` — tout est géré via PHPStorm

### References

- [Source: architecture.md#Infrastructure & Deployment] — Outils qualité
- [Source: architecture.md#Frontend Architecture] — Very Good CLI standard
- [Source: epics.md#Story 0.3] — Acceptance criteria BDD
- [Source: architecture.md#Enforcement Guidelines] — Standards de qualité obligatoires

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
