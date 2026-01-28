# Story 2.2 : Consultation et liste des fiches annonces

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter la liste de toutes mes fiches et voir le détail de chacune,
So that j'ai une vue d'ensemble de mes opportunités.

## Acceptance Criteria

1. **Given** un utilisateur connecté avec des fiches existantes
   **When** il accède à l'écran liste des fiches
   **Then** toutes ses fiches sont affichées avec adresse, prix, type de bien et urgence
   **And** la liste est triée par date de création (plus récente en premier)

2. **Given** la liste des fiches
   **When** l'utilisateur tapote sur une fiche
   **Then** l'écran détail affiche toutes les informations : bien, agent, urgence, notes

## Tasks / Subtasks

- [ ] Task 1 : Compléter PropertyCubit avec chargement liste (AC: #1)
  - [ ] 1.1 Dans `lib/features/properties/presentation/cubit/property_cubit.dart` :
    - Méthode `loadProperties()` qui appelle `repository.getProperties()`
    - Emit `PropertyLoading` puis `PropertyLoaded(properties)` ou `PropertyError`
    - Méthode `watchProperties()` qui écoute le stream Drift via repository
  - [ ] 1.2 Ajouter state `PropertyLoaded(List<PropertyModel> properties)` si pas déjà fait
  - [ ] 1.3 S'assurer que le repository retourne les fiches triées par `created_at DESC`

- [ ] Task 2 : Implémenter tri côté repository (AC: #1)
  - [ ] 2.1 Dans `lib/features/properties/data/property_local_source.dart` :
    - Modifier `getAll()` pour trier par `createdAt` descendant
    - Query Drift : `select(propertiesTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])`
  - [ ] 2.2 Dans `app/Http/Controllers/Api/PropertyController.php` :
    - Méthode `index()` retourne `Property::orderBy('created_at', 'desc')->get()`
    - Utiliser `PropertyResource::collection($properties)`

- [ ] Task 3 : Créer l'écran liste des fiches (AC: #1)
  - [ ] 3.1 Créer `lib/features/properties/presentation/pages/properties_list_page.dart` avec :
    - `BlocProvider` pour `PropertyCubit`
    - `BlocBuilder<PropertyCubit, PropertyState>` qui affiche :
      - Loading : skeleton/shimmer
      - Loaded : ListView avec PropertyCard pour chaque fiche
      - Error : message d'erreur avec retry
    - `onInit` : appeler `propertyCubit.loadProperties()`
  - [ ] 3.2 Créer widget `lib/features/properties/presentation/widgets/property_card.dart` avec :
    - Affichage : adresse, prix formaté (centimes → euros), type de bien, badge urgence
    - onTap : navigation vers `/properties/{id}`
    - Design adaptatif via `adaptive_platform_ui` (Cupertino iOS, Material Android)
  - [ ] 3.3 Ajouter la route dans `lib/app/routes.dart` : `/properties` (page d'accueil ou via bottom nav)

- [ ] Task 4 : Créer l'écran détail d'une fiche (AC: #2)
  - [ ] 4.1 Créer `lib/features/properties/presentation/pages/property_detail_page.dart` avec :
    - Paramètre route : `String propertyId`
    - `BlocBuilder<PropertyCubit, PropertyState>` qui récupère la fiche depuis le state
    - Sections UI :
      - Header : adresse, type de bien
      - Section "Informations du bien" : surface, prix, urgence
      - Section "Agent immobilier" (si renseigné) : nom, agence, téléphone
      - Section "Notes" (si renseignées) : affichage texte multiligne
    - Boutons actions : "Modifier" (navigation vers edit), "Supprimer" (story 2.3)
  - [ ] 4.2 Créer widgets de détail réutilisables :
    - `property_info_section.dart` : affiche informations bien
    - `property_agent_section.dart` : affiche informations agent
    - `property_notes_section.dart` : affiche notes
  - [ ] 4.3 Ajouter la route dans `lib/app/routes.dart` : `/properties/:id`

- [ ] Task 5 : Améliorer PropertyRepository pour récupérer une fiche par ID (AC: #2)
  - [ ] 5.1 Dans `lib/features/properties/data/property_local_source.dart` :
    - S'assurer que `getById(String id)` est implémenté
    - Query Drift : `(select(propertiesTable)..where((t) => t.id.equals(id))).getSingleOrNull()`
  - [ ] 5.2 Dans `lib/features/properties/data/property_repository.dart` :
    - Méthode `Future<PropertyModel?> getPropertyById(String id)`
    - Appelle local source, si null et réseau disponible, tente fetch remote
  - [ ] 5.3 Ajouter méthode dans PropertyCubit : `loadPropertyById(String id)` → emit state avec fiche

- [ ] Task 6 : Formater les montants et affichage UI (AC: #1, #2)
  - [ ] 6.1 Créer helper `lib/core/utils/currency_formatter.dart` :
    - Fonction `formatPrice(int priceInCents)` → `"1 500,00 €"`
    - Locale FR avec séparateur milliers espace, décimales virgule
  - [ ] 6.2 Utiliser `formatPrice` dans PropertyCard et PropertyDetailPage
  - [ ] 6.3 Créer helper `lib/core/utils/enum_formatter.dart` :
    - Fonction `formatPropertyType(PropertyType type)` → "Appartement", "Maison", etc.
    - Fonction `formatSaleUrgency(SaleUrgency urgency)` → badge coloré (vert/orange/rouge)

- [ ] Task 7 : Tests unitaires et widget (AC: #1, #2)
  - [ ] 7.1 Créer `test/features/properties/presentation/cubit/property_cubit_test.dart` :
    - Test `loadProperties()` emit `PropertyLoaded` avec liste triée
    - Mock `PropertyRepository`
  - [ ] 7.2 Créer `test/features/properties/presentation/widgets/property_card_test.dart` :
    - Test affichage adresse, prix formaté, type de bien, badge urgence
    - Test onTap navigation
  - [ ] 7.3 Créer `test/features/properties/presentation/pages/property_detail_page_test.dart` :
    - Test affichage toutes sections (bien, agent, notes)
  - [ ] 7.4 Vérifier lint : `very_good analyze`

- [ ] Task 8 : Validation finale (AC: #1, #2)
  - [ ] 8.1 Test manuel : créer plusieurs fiches → vérifier affichage liste triée par date décroissante
  - [ ] 8.2 Test manuel : tapote sur fiche → vérifier navigation vers détail avec toutes infos
  - [ ] 8.3 Test manuel : fiche avec agent + notes → vérifier affichage sections
  - [ ] 8.4 Test manuel : fiche sans agent ni notes → vérifier sections masquées
  - [ ] 8.5 Test offline : consultation liste et détail sans réseau → vérifier données locales Drift
  - [ ] 8.6 Commit : `git add . && git commit -m "feat: consultation et liste fiches annonces (Story 2.2)"`

## Dev Notes

### Architecture & Contraintes

- **Dépendance Story 2.1** : Cette story nécessite que le modèle Property, le repository et la table Drift soient déjà implémentés [Source: epics.md#Story 2.2]
- **Tri par défaut** : La liste est toujours triée par `created_at DESC` pour afficher les fiches les plus récentes en premier [Source: epics.md#Story 2.2, AC #1]
- **Offline-first** : La liste et le détail doivent fonctionner entièrement offline via Drift [Source: architecture.md#Data Architecture]
- **Reactive UI** : Utiliser le stream Drift `watchProperties()` pour mettre à jour automatiquement la liste si une fiche est créée/modifiée ailleurs [Source: architecture.md#Frontend Architecture]

### Structure PropertyCubit states

```dart
// lib/features/properties/presentation/cubit/property_state.dart
abstract class PropertyState extends Equatable {
  const PropertyState();
}

class PropertyInitial extends PropertyState {
  @override
  List<Object> get props => [];
}

class PropertyLoading extends PropertyState {
  @override
  List<Object> get props => [];
}

class PropertyLoaded extends PropertyState {
  final List<PropertyModel> properties;
  const PropertyLoaded(this.properties);
  @override
  List<Object> get props => [properties];
}

class PropertyError extends PropertyState {
  final String message;
  const PropertyError(this.message);
  @override
  List<Object> get props => [message];
}

class PropertyCreated extends PropertyState {
  final PropertyModel property;
  const PropertyCreated(this.property);
  @override
  List<Object> get props => [property];
}
```

### Query Drift avec tri

```dart
// lib/features/properties/data/property_local_source.dart
Future<List<PropertyModel>> getAll() async {
  final query = select(propertiesTable)
    ..where((t) => t.deletedAt.isNull()) // exclure soft-deleted
    ..orderBy([
      (t) => OrderingTerm.desc(t.createdAt)
    ]);

  final results = await query.get();
  return results.map((data) => PropertyModel.fromDrift(data)).toList();
}
```

### PropertyCard widget

```dart
// lib/features/properties/presentation/widgets/property_card.dart
class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return AdaptiveCard( // adaptive_platform_ui
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(property.address, style: heading),
          Row(
            children: [
              Text(formatPrice(property.price)),
              Spacer(),
              SaleUrgencyBadge(urgency: property.saleUrgency),
            ],
          ),
          Text(formatPropertyType(property.propertyType)),
        ],
      ),
    );
  }
}
```

### Formatage montant

```dart
// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

String formatPrice(int priceInCents) {
  final euros = priceInCents / 100;
  final formatter = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 2,
  );
  return formatter.format(euros); // "1 500,00 €"
}
```

### Navigation GoRouter

```dart
// lib/app/routes.dart
final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/properties',
      builder: (context, state) => PropertiesListPage(),
    ),
    GoRoute(
      path: '/properties/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PropertyDetailPage(propertyId: id);
      },
    ),
    GoRoute(
      path: '/properties/create',
      builder: (context, state) => CreatePropertyPage(),
    ),
  ],
);
```

### Backend index endpoint

```php
// app/Http/Controllers/Api/PropertyController.php
public function index(Request $request)
{
    $properties = Property::where('user_id', $request->user()->id)
        ->whereNull('deleted_at')
        ->orderBy('created_at', 'desc')
        ->get();

    return PropertyResource::collection($properties);
}
```

### Project Structure Notes

Cette story complète la feature `properties` avec les écrans de consultation :

```
mobile-app/
├── lib/
│   ├── core/utils/
│   │   ├── currency_formatter.dart
│   │   └── enum_formatter.dart
│   └── features/properties/
│       └── presentation/
│           ├── cubit/
│           │   ├── property_cubit.dart (complété)
│           │   └── property_state.dart (complété)
│           ├── pages/
│           │   ├── properties_list_page.dart
│           │   ├── property_detail_page.dart
│           │   └── create_property_page.dart (Story 2.1)
│           └── widgets/
│               ├── property_card.dart
│               ├── property_info_section.dart
│               ├── property_agent_section.dart
│               └── property_notes_section.dart
├── test/features/properties/
│   └── presentation/
│       ├── cubit/property_cubit_test.dart
│       ├── pages/property_detail_page_test.dart
│       └── widgets/property_card_test.dart
```

[Source: architecture.md#Project Structure & Boundaries]

### References

- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit states, GoRouter
- [Source: architecture.md#Data Architecture] — Drift reactive streams
- [Source: architecture.md#Naming Patterns] — camelCase Dart, PascalCase classes
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Repository pattern, formatage montants
- [Source: epics.md#Story 2.2] — Acceptance criteria BDD, dépendance Story 2.1

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
