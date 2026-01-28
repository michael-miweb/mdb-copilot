# Story 9.1 : Récupération et affichage des données DVF

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter les transactions immobilières récentes autour d'une annonce,
So that j'évalue objectivement si le prix demandé est cohérent avec le marché.

## Acceptance Criteria

1. **Given** une fiche annonce avec une adresse renseignée
   **When** l'utilisateur demande les données DVF
   **Then** le système interroge l'API DVF via le proxy Laravel
   **And** les transactions récentes dans un rayon pertinent sont affichées
   **And** les données incluent : adresse, surface, prix, date de transaction, type de bien

2. **Given** les données DVF affichées
   **When** l'utilisateur les consulte
   **Then** un comparatif prix/m² est affiché entre l'annonce et les transactions récentes
   **And** une indication visuelle montre si le prix est au-dessus, dans la moyenne ou en dessous du marché

## Tasks / Subtasks

- [ ] Task 1 : Créer le service proxy DVF Laravel (AC: #1)
  - [ ] 1.1 Créer le service : `php artisan make:service DvfService`
  - [ ] 1.2 Implémenter `fetchTransactionsByLocation($lat, $lon, $radius = 1000)` : requête vers l'API data.gouv.fr DVF
  - [ ] 1.3 Parser la réponse JSON de l'API DVF et extraire : `adresse`, `surface`, `prix`, `date_transaction`, `type_bien`
  - [ ] 1.4 Implémenter le cache Laravel : `Cache::remember("dvf_{$lat}_{$lon}_{$radius}", now()->addHours(24), ...)`
  - [ ] 1.5 Gérer les erreurs API (timeout, 404, 500) et retourner un tableau vide avec log
  - [ ] 1.6 Filtrer les transactions sur les 3 dernières années uniquement

- [ ] Task 2 : Créer le controller Laravel et les routes API (AC: #1, #2)
  - [ ] 2.1 Créer le controller : `php artisan make:controller Api/DvfController`
  - [ ] 2.2 Implémenter `index(Request $request)` : récupère `lat`, `lon`, `radius` depuis query params
  - [ ] 2.3 Valider les paramètres : `lat` (float, required), `lon` (float, required), `radius` (int, default 1000, max 5000)
  - [ ] 2.4 Appeler `DvfService::fetchTransactionsByLocation()`
  - [ ] 2.5 Calculer le prix moyen au m² pour les transactions récupérées
  - [ ] 2.6 Retourner JSON : `{ "transactions": [...], "avg_price_per_sqm": 2500, "count": 15 }`
  - [ ] 2.7 Ajouter les routes dans `routes/api.php` : `Route::get('/dvf', [DvfController::class, 'index'])->middleware('auth:sanctum')`

- [ ] Task 3 : Créer le repository Flutter (AC: #1)
  - [ ] 3.1 Créer `mobile-app/lib/features/dvf/data/dvf_repository.dart`
  - [ ] 3.2 Créer `dvf_remote_source.dart` : méthode `fetchDvfTransactions(double lat, double lon, int radius)` via API client
  - [ ] 3.3 Créer le modèle `dvf_transaction_model.dart` avec `fromJson()`, champs : `address`, `surface`, `price`, `transactionDate`, `propertyType`
  - [ ] 3.4 Créer le modèle `dvf_result_model.dart` : `List<DvfTransaction> transactions`, `double avgPricePerSqm`, `int count`
  - [ ] 3.5 Implémenter le repository : `fetchDvfData(double lat, double lon, int radius)` appelle remote source et retourne `DvfResult`
  - [ ] 3.6 Gérer les erreurs réseau : retourner `Left(NetworkFailure)` en cas d'échec

- [ ] Task 4 : Créer le Cubit Flutter (AC: #1, #2)
  - [ ] 4.1 Créer `mobile-app/lib/features/dvf/presentation/cubit/dvf_cubit.dart`
  - [ ] 4.2 Définir les states : `DvfInitial`, `DvfLoading`, `DvfLoaded`, `DvfError`
  - [ ] 4.3 Implémenter `loadDvfData(double lat, double lon, int radius)` : appelle le repository, émet `Loading` puis `Loaded` ou `Error`
  - [ ] 4.4 Dans `DvfLoaded`, stocker `DvfResult` avec `transactions`, `avgPricePerSqm`, `count`
  - [ ] 4.5 Ajouter une méthode `comparePriceToMarket(double propertyPrice, double propertySurface)` : retourne enum `Above`, `Average`, `Below` selon comparaison avec `avgPricePerSqm`

- [ ] Task 5 : Créer l'interface utilisateur Flutter (AC: #1, #2)
  - [ ] 5.1 Créer `mobile-app/lib/features/dvf/presentation/pages/dvf_data_page.dart`
  - [ ] 5.2 Afficher un bouton "Voir les données DVF" dans la fiche annonce (detail page)
  - [ ] 5.3 Au tap, récupérer lat/lon de l'adresse de la fiche annonce (via geocoding si nécessaire) et appeler `loadDvfData()`
  - [ ] 5.4 Afficher un loader pendant `DvfLoading`
  - [ ] 5.5 Afficher la liste des transactions récentes avec : adresse, surface, prix, prix/m², date, type de bien
  - [ ] 5.6 Afficher une section "Comparaison prix/m²" avec : prix/m² de l'annonce vs prix/m² moyen des transactions
  - [ ] 5.7 Créer `mobile-app/lib/features/dvf/presentation/widgets/market_comparison_widget.dart` : affiche une jauge visuelle (vert/orange/rouge) selon si le prix est en dessous/moyen/au-dessus du marché
  - [ ] 5.8 Afficher un message si aucune transaction n'est trouvée : "Aucune transaction récente dans le rayon"
  - [ ] 5.9 Afficher un message d'erreur si l'API DVF est indisponible : "Données DVF temporairement indisponibles"

- [ ] Task 6 : Geocoding de l'adresse (AC: #1)
  - [ ] 6.1 Ajouter le package `geocoding: ^3.0.0` dans `mobile-app/pubspec.yaml`
  - [ ] 6.2 Dans `properties` feature, ajouter une méthode `getCoordinatesFromAddress(String address)` qui retourne `(lat, lon)`
  - [ ] 6.3 Stocker lat/lon dans la table `properties` Drift et dans le modèle Laravel `Property` (colonnes `latitude`, `longitude`)
  - [ ] 6.4 Lors de la création/modification d'une fiche annonce, calculer lat/lon via geocoding et stocker dans DB
  - [ ] 6.5 Utiliser ces coordonnées pour la requête DVF

- [ ] Task 7 : Tests backend (AC: #1, #2)
  - [ ] 7.1 Créer `tests/Unit/Services/DvfServiceTest.php` : mocker l'API DVF, tester parsing et cache
  - [ ] 7.2 Créer `tests/Feature/Api/DvfControllerTest.php` : tester endpoint `/api/dvf` avec params valides et invalides
  - [ ] 7.3 Vérifier que le cache fonctionne : deux requêtes identiques dans les 24h ne doivent faire qu'un appel API
  - [ ] 7.4 Vérifier que les transactions anciennes (> 3 ans) sont filtrées

- [ ] Task 8 : Tests frontend (AC: #1, #2)
  - [ ] 8.1 Créer `test/features/dvf/data/dvf_repository_test.dart` : mocker remote source, tester success et failure
  - [ ] 8.2 Créer `test/features/dvf/presentation/cubit/dvf_cubit_test.dart` : tester états Loading, Loaded, Error
  - [ ] 8.3 Créer widget tests pour `market_comparison_widget.dart` : vérifier affichage jauge selon prix

- [ ] Task 9 : Validation finale (AC: #1, #2)
  - [ ] 9.1 Vérifier qu'une fiche annonce avec adresse valide affiche les transactions DVF récentes
  - [ ] 9.2 Vérifier que le comparatif prix/m² s'affiche correctement
  - [ ] 9.3 Vérifier que la jauge visuelle indique correctement si le prix est au-dessus/moyen/en dessous
  - [ ] 9.4 Vérifier que le cache fonctionne : une deuxième requête identique ne déclenche pas d'appel API (vérifier logs)
  - [ ] 9.5 Vérifier que l'API retourne un message clair si aucune transaction n'est trouvée
  - [ ] 9.6 Vérifier que l'API gère correctement une erreur de l'API DVF externe

## Dev Notes

### Architecture & Contraintes

- **Proxy Laravel** : Le backend Laravel sert de proxy vers l'API data.gouv.fr pour éviter d'exposer les clés API côté client et pour centraliser le cache. [Source: architecture.md#External Integrations]
- **Cache 24h** : Les données DVF sont mises en cache côté Laravel pour 24 heures afin de limiter les appels à l'API externe et améliorer la performance. [Source: architecture.md#Data Architecture]
- **Filtrage temporel** : Seules les transactions des 3 dernières années sont pertinentes pour l'analyse de marché. [Source: epics.md#Story 9.1]
- **Geocoding** : La conversion adresse → lat/lon se fait côté Flutter via le package `geocoding`. Les coordonnées sont stockées dans la fiche annonce pour éviter de recalculer à chaque requête DVF. [Source: architecture.md#Frontend Architecture]

### API data.gouv.fr DVF

**Endpoint :** `https://api.cquest.org/dvf`

**Exemple de requête :**
```
GET https://api.cquest.org/dvf?lat=48.8566&lon=2.3522&dist=1000
```

**Paramètres :**
- `lat` : latitude (float)
- `lon` : longitude (float)
- `dist` : rayon en mètres (int, max 5000)

**Réponse :** JSON array de transactions avec champs `adresse`, `surface_reelle_bati`, `valeur_fonciere`, `date_mutation`, `type_local`

**Note :** Les données DVF ont environ 6 mois de retard par rapport aux transactions réelles. [Source: architecture.md#Technical Constraints & Dependencies]

### Calcul du comparatif prix

**Logique Flutter :**
```dart
enum MarketPosition { below, average, above }

MarketPosition comparePriceToMarket(
  double propertyPrice,
  double propertySurface,
  double avgPricePerSqm,
) {
  final propertyPricePerSqm = propertyPrice / propertySurface;
  final difference = (propertyPricePerSqm - avgPricePerSqm) / avgPricePerSqm;

  if (difference < -0.10) return MarketPosition.below;  // -10% ou plus
  if (difference > 0.10) return MarketPosition.above;   // +10% ou plus
  return MarketPosition.average;                        // ±10%
}
```

**Affichage visuel :**
- `Below` (en dessous) : badge vert "Bon prix" 🟢
- `Average` (moyenne) : badge orange "Prix marché" 🟠
- `Above` (au-dessus) : badge rouge "Prix élevé" 🔴

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   └── features/
│       └── dvf/
│           ├── data/
│           │   ├── dvf_repository.dart
│           │   ├── dvf_remote_source.dart
│           │   └── models/
│           │       ├── dvf_transaction_model.dart
│           │       └── dvf_result_model.dart
│           └── presentation/
│               ├── cubit/
│               │   ├── dvf_cubit.dart
│               │   └── dvf_state.dart
│               ├── pages/
│               │   └── dvf_data_page.dart
│               └── widgets/
│                   ├── dvf_transaction_tile.dart
│                   └── market_comparison_widget.dart

backend-api/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       └── Api/
│   │           └── DvfController.php
│   └── Services/
│       └── DvfService.php
└── routes/
    └── api.php
```

### References

- [Source: epics.md#Story 9.1] — FR35, FR36 : Récupération DVF, comparaison prix/m²
- [Source: architecture.md#External Integrations] — DVF data.gouv.fr proxy Laravel
- [Source: architecture.md#Data Architecture] — Cache Laravel 24h
- [Source: architecture.md#API & Communication Patterns] — Routes `/api/dvf`
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Repository pattern, error handling

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
