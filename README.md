# MDB Copilot

Assistant numérique pour Marchands de Biens. Application mobile + API backend pour gérer le pipeline d'acquisitions immobilières, de la prospection à la revente.

## Structure

```
mobile-app/     # Flutter (Very Good CLI) — iOS, Android, Web
backend-api/    # Laravel 12 + Sanctum — API REST JSON
```

## Stack technique

- **Frontend :** Flutter 3.38+ / Very Good CLI / Bloc-Cubit / Drift (SQLite)
- **Backend :** Laravel 12 / Sanctum / Sail (Docker) / MySQL 8
- **Dev local :** Laravel Sail (ports préfixe 4)
- **Prod :** FrankenPHP + Octane / Docker

## Ports Sail (développement)

| Service           | Port  |
| ----------------- | ----- |
| App               | 4080  |
| MySQL             | 43306 |
| Vite              | 45173 |
| Mailpit SMTP      | 41025 |
| Mailpit Dashboard | 48025 |

## Démarrage rapide

```bash
# Backend
cd backend-api
./vendor/bin/sail up -d

# Frontend
cd mobile-app
flutter run --flavor development --target lib/main_development.dart
```
