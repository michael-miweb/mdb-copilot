# Story 9.2 : Cache DVF et consultation offline

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter les données DVF déjà téléchargées même sans connexion,
So that j'ai accès aux données marché lors de mes visites terrain.

## Acceptance Criteria

1. **Given** des données DVF téléchargées pour une fiche
   **When** l'appareil passe hors connexion
   **Then** les données DVF en cache restent consultables

2. **Given** une requête DVF
   **When** le cache contient des données récentes (< 24h)
   **Then** le cache est utilisé sans nouvelle requête réseau
   **And** la date de dernière mise à jour est affichée

3. **Given** une requête DVF
   **When** l'API DVF est indisponible
   **Then** un message informe l'utilisateur
   **And** les données en cache (même anciennes) restent consultables avec mention de la date

## Tasks / Subtasks

- [ ] Task 1 : Créer la table Drift pour le cache DVF (AC: #1, #2, #3)
  - [ ] 1.1 Créer `dvf_cache_table.dart` dans `mobile-app/lib/core/db/tables/`
  - [ ] 1.2 Définir les colonnes : `id` (UUID v4), `property_id` (foreign key), `lat` (real), `lon` (real), `radius` (int), `transactions_json` (text), `avg_price_per_sqm` (real), `count` (int), `cached_at` (datetime), `updated_at` (datetime)
  - [ ] 1.3 Ajouter une foreign key vers `properties_table`
  - [ ] 1.4 Intégrer la table dans `app_database.dart`
  - [ ] 1.5 Générer la migration : `dart run build_runner build`

- [ ] Task 2 : Créer la source de données locale DVF (AC: #1, #2, #3)
  - [ ] 2.1 Créer `mobile-app/lib/features/dvf/data/dvf_local_source.dart`
  - [ ] 2.2 Implémenter `getDvfCache(String propertyId)` : récupère le cache DVF depuis Drift par `property_id`
  - [ ] 2.3 Implémenter `insertDvfCache(DvfCache cache)` : insère ou remplace le cache dans Drift
  - [ ] 2.4 Implémenter `isCacheValid(DateTime cachedAt, Duration ttl)` : vérifie si le cache est encore valide selon TTL (24h par défaut)
  - [ ] 2.5 Créer le modèle `dvf_cache_model.dart` avec `toTable()`, `fromTable()` pour mapping Drift

- [ ] Task 3 : Modifier le repository DVF pour utiliser le cache local (AC: #1, #2, #3)
  - [ ] 3.1 Modifier `dvf_repository.dart` : ajouter `DvfLocalSource` en dépendance
  - [ ] 3.2 Dans `fetchDvfData(String propertyId, double lat, double lon, int radius)` :
  - [ ] 3.3 Étape 1 : Vérifier si un cache existe pour cette `property_id` via local source
  - [ ] 3.4 Étape 2 : Si cache existe et est valide (< 24h), retourner les données du cache sans requête réseau
  - [ ] 3.5 Étape 3 : Si cache invalide ou inexistant, tenter requête réseau via remote source
  - [ ] 3.6 Étape 4 : Si requête réseau réussit, sauvegarder le résultat dans le cache local avec timestamp
  - [ ] 3.7 Étape 5 : Si requête réseau échoue, vérifier si un cache ancien existe, si oui le retourner avec flag `isStale: true`
  - [ ] 3.8 Étape 6 : Si aucun cache et réseau échoue, retourner `Left(NetworkFailure)`

- [ ] Task 4 : Ajouter le metadata de cache dans le state (AC: #2, #3)
  - [ ] 4.1 Modifier `dvf_state.dart` : ajouter les champs `DateTime? cachedAt`, `bool isStale` dans `DvfLoaded`
  - [ ] 4.2 Modifier le Cubit pour passer ces infos depuis le repository
  - [ ] 4.3 `isStale = true` si le cache a plus de 24h et qu'aucune requête réseau n'a pu être effectuée

- [ ] Task 5 : Afficher les informations de cache dans l'UI (AC: #2, #3)
  - [ ] 5.1 Modifier `dvf_data_page.dart` pour afficher la date de dernière mise à jour en haut de la page
  - [ ] 5.2 Format : "Données mises à jour le {date} à {heure}" si cache < 24h
  - [ ] 5.3 Format : "⚠️ Données du {date} (mises à jour automatiquement à la connexion)" si `isStale = true`
  - [ ] 5.4 Afficher une icône "Disponible hors ligne" 🔄 si des données en cache existent
  - [ ] 5.5 Si requête réseau échoue et aucun cache, afficher : "Impossible de récupérer les données DVF. Vérifiez votre connexion."

- [ ] Task 6 : Gérer le mode offline dans le Cubit (AC: #1)
  - [ ] 6.1 Ajouter une vérification de connectivité réseau avant d'appeler remote source
  - [ ] 6.2 Si offline et cache existe, retourner immédiatement le cache sans tenter requête réseau
  - [ ] 6.3 Afficher un message discret : "Mode hors ligne - données du cache local"

- [ ] Task 7 : Ajouter une stratégie de rafraîchissement (AC: #2)
  - [ ] 7.1 Ajouter un bouton "Actualiser" dans `dvf_data_page.dart`
  - [ ] 7.2 Au tap, forcer une nouvelle requête réseau même si cache valide
  - [ ] 7.3 Si succès, remplacer le cache avec les nouvelles données
  - [ ] 7.4 Si échec réseau, conserver le cache existant et afficher un message : "Impossible d'actualiser, données en cache conservées"

- [ ] Task 8 : Tests backend (cache Laravel déjà testé dans Story 9.1) (AC: #2, #3)
  - [ ] 8.1 Vérifier que le cache Laravel fonctionne toujours : deux requêtes identiques < 24h = un seul appel API DVF
  - [ ] 8.2 Vérifier que le backend retourne une erreur explicite si API DVF indisponible

- [ ] Task 9 : Tests frontend (AC: #1, #2, #3)
  - [ ] 9.1 Créer `test/features/dvf/data/dvf_local_source_test.dart` : tester insert, get, validation cache TTL
  - [ ] 9.2 Créer `test/features/dvf/data/dvf_repository_test.dart` (étendre) : tester logique cache local + remote fallback
  - [ ] 9.3 Mocker `ConnectivityMonitor` pour simuler offline : vérifier que le cache local est utilisé
  - [ ] 9.4 Mocker une erreur réseau : vérifier que le cache ancien est retourné avec `isStale = true`
  - [ ] 9.5 Créer widget test pour `dvf_data_page.dart` : vérifier affichage date mise à jour et message stale

- [ ] Task 10 : Validation finale (AC: #1, #2, #3)
  - [ ] 10.1 Vérifier qu'une requête DVF avec connexion met en cache les données localement
  - [ ] 10.2 Désactiver le réseau (mode avion) et vérifier que les données DVF restent consultables depuis le cache
  - [ ] 10.3 Vérifier que la date de dernière mise à jour s'affiche correctement
  - [ ] 10.4 Vérifier qu'une deuxième requête DVF < 24h utilise le cache sans requête réseau (vérifier logs)
  - [ ] 10.5 Simuler une erreur API DVF : vérifier que le cache ancien est utilisé avec message "données anciennes"
  - [ ] 10.6 Vérifier que le bouton "Actualiser" force une nouvelle requête réseau et met à jour le cache
  - [ ] 10.7 Vérifier qu'en mode offline, le message "Mode hors ligne - données du cache local" s'affiche

## Dev Notes

### Architecture & Contraintes

- **Offline-first** : Les données DVF sont stockées localement après la première récupération pour permettre la consultation sans connexion. [Source: architecture.md#Data Architecture]
- **Cache TTL 24h** : Les données DVF sont considérées valides pendant 24 heures. Après ce délai, une nouvelle requête réseau est tentée. [Source: architecture.md#Data Architecture]
- **Graceful degradation** : Si le réseau échoue et qu'un cache ancien existe, l'application utilise le cache ancien avec un avertissement utilisateur. [Source: architecture.md#Process Patterns]
- **Dépendance Story 9.1** : Cette story étend la Story 9.1 en ajoutant la couche de cache local. Le backend et l'API DVF doivent déjà être fonctionnels. [Source: epics.md#Story 9.2]

### Stratégie de cache

**Flux de décision :**
```
1. Utilisateur demande données DVF pour une fiche
2. Repository vérifie cache local Drift
3. SI cache existe ET < 24h → retourner cache (pas de réseau)
4. SI cache n'existe pas OU > 24h → tenter requête réseau
5. SI requête réseau OK → sauvegarder dans cache + retourner
6. SI requête réseau KO ET cache ancien existe → retourner cache ancien avec flag isStale
7. SI requête réseau KO ET pas de cache → erreur NetworkFailure
```

**Avantages :**
- Performance : pas de requête réseau si cache valide
- Offline : consultation des données même sans connexion
- Résilience : fallback sur cache ancien si API indisponible

### Modèle de données cache

**Table Drift `dvf_cache_table.dart` :**
```dart
class DvfCache extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get propertyId => text().customConstraint('REFERENCES properties(id) ON DELETE CASCADE')();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  IntColumn get radius => integer()();
  TextColumn get transactionsJson => text()(); // JSON serialized List<DvfTransaction>
  RealColumn get avgPricePerSqm => real()();
  IntColumn get count => integer()();
  DateTimeColumn get cachedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Note :** `transactionsJson` stocke la liste des transactions en JSON sérialisé. Cela évite de créer une table relationnelle complexe pour des données temporaires.

### TTL et validation du cache

**Constante TTL :**
```dart
const dvfCacheTtl = Duration(hours: 24);

bool isCacheValid(DateTime cachedAt) {
  return DateTime.now().difference(cachedAt) < dvfCacheTtl;
}
```

**Cas d'usage :**
- Cache < 24h + connexion disponible → utiliser cache (pas de requête)
- Cache > 24h + connexion disponible → requête réseau + mise à jour cache
- Cache > 24h + connexion indisponible → utiliser cache avec flag `isStale = true`
- Pas de cache + connexion indisponible → erreur NetworkFailure

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   ├── core/
│   │   └── db/
│   │       └── tables/
│   │           └── dvf_cache_table.dart
│   └── features/
│       └── dvf/
│           ├── data/
│           │   ├── dvf_repository.dart           # Modifié : logique cache
│           │   ├── dvf_local_source.dart         # Nouveau
│           │   ├── dvf_remote_source.dart        # Existant (Story 9.1)
│           │   └── models/
│           │       ├── dvf_transaction_model.dart # Existant
│           │       ├── dvf_result_model.dart      # Existant
│           │       └── dvf_cache_model.dart       # Nouveau
│           └── presentation/
│               ├── cubit/
│               │   ├── dvf_cubit.dart             # Modifié
│               │   └── dvf_state.dart             # Modifié : ajout cachedAt, isStale
│               ├── pages/
│               │   └── dvf_data_page.dart         # Modifié : affichage date + stale warning
│               └── widgets/
│                   ├── dvf_transaction_tile.dart  # Existant
│                   ├── market_comparison_widget.dart # Existant
│                   └── cache_status_banner.dart   # Nouveau (optionnel)
```

### References

- [Source: epics.md#Story 9.2] — FR37 : Cache local DVF, consultation offline
- [Source: epics.md#Story 9.1] — Dépendance : API DVF et remote source
- [Source: architecture.md#Data Architecture] — Cache TTL 24h, offline-first
- [Source: architecture.md#Process Patterns] — Graceful degradation, error handling
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Repository pattern, Drift

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
