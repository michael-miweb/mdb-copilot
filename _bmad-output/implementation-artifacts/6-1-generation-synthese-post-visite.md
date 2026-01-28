# Story 6.1 : Génération automatique de la synthèse post-visite

Status: ready-for-dev

## Story

As a utilisateur,
I want que le système génère une synthèse complète basée sur mes réponses du guide de visite,
So that j'ai un récapitulatif structuré sans effort de rédaction.

## Acceptance Criteria

1. **Given** un guide de visite avec des réponses complétées
   **When** l'utilisateur demande la synthèse post-visite
   **Then** le système génère une synthèse récapitulant les constats par catégorie
   **And** la synthèse est générée côté client (logique embarquée)
   **And** la synthèse est stockée et liée à la fiche annonce

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle de données pour la synthèse post-visite (AC: #1)
  - [ ] 1.1 Créer la table Drift `post_visit_summaries_table.dart` avec colonnes : id (UUID), property_id (FK), generated_at, summary_data (JSON), created_at, updated_at, syncStatus
  - [ ] 1.2 Ajouter la relation dans `properties_table.dart` : une propriété peut avoir plusieurs synthèses
  - [ ] 1.3 Créer le modèle Dart `PostVisitSummary` avec factory fromJson/toJson
  - [ ] 1.4 Ajouter les méthodes CRUD dans l'AppDatabase Drift

- [ ] Task 2 : Implémenter la logique de génération côté client (AC: #1)
  - [ ] 2.1 Créer `PostVisitSummaryService` dans `lib/features/post_visit_summary/data/`
  - [ ] 2.2 Implémenter la méthode `generateSummary(String propertyId)` qui :
    - Récupère les réponses du guide de visite via `VisitGuideRepository`
    - Agrège les constats par catégorie (structure, électricité, plomberie, etc.)
    - Génère un texte récapitulatif structuré pour chaque catégorie
    - Crée un objet `PostVisitSummary` avec summary_data en JSON
  - [ ] 2.3 Implémenter la logique d'agrégation par catégorie avec détection de patterns
  - [ ] 2.4 Tester la génération avec différents jeux de réponses (unitaires)

- [ ] Task 3 : Créer le Repository (AC: #1)
  - [ ] 3.1 Créer `PostVisitSummaryRepository` avec abstraction local/remote
  - [ ] 3.2 Créer `PostVisitSummaryLocalSource` utilisant Drift
  - [ ] 3.3 Implémenter les méthodes : saveSummary, getSummaryByPropertyId, updateSummary, deleteSummary
  - [ ] 3.4 Marquer syncStatus = pending lors de la création/modification
  - [ ] 3.5 Tester le Repository avec mocks Drift

- [ ] Task 4 : Créer le Cubit de présentation (AC: #1)
  - [ ] 4.1 Créer `PostVisitSummaryCubit` dans `lib/features/post_visit_summary/presentation/cubit/`
  - [ ] 4.2 Définir les states : Initial, Loading, Loaded(summary), Error(message)
  - [ ] 4.3 Implémenter la méthode `generateSummary(String propertyId)` qui appelle le service
  - [ ] 4.4 Implémenter `loadSummary(String propertyId)` pour consultation
  - [ ] 4.5 Tester le Cubit avec mocks du Repository

- [ ] Task 5 : Créer l'écran de synthèse (AC: #1)
  - [ ] 5.1 Créer `PostVisitSummaryPage` dans `lib/features/post_visit_summary/presentation/pages/`
  - [ ] 5.2 Afficher le récapitulatif par catégorie avec sections accordéon/expandable
  - [ ] 5.3 Afficher la date de génération
  - [ ] 5.4 Ajouter bouton "Regénérer la synthèse" si les réponses du guide ont changé
  - [ ] 5.5 Afficher un skeleton loader pendant la génération
  - [ ] 5.6 Gérer les erreurs avec message explicite

- [ ] Task 6 : Intégration avec la fiche annonce (AC: #1)
  - [ ] 6.1 Ajouter un bouton "Voir la synthèse" dans `PropertyDetailPage`
  - [ ] 6.2 Navigation vers `PostVisitSummaryPage` avec propertyId
  - [ ] 6.3 Si aucune synthèse n'existe, proposer de la générer
  - [ ] 6.4 Afficher un indicateur "Synthèse disponible" sur la carte propriété si synthèse existe

- [ ] Task 7 : Tests d'intégration (AC: #1)
  - [ ] 7.1 Tester le flow complet : guide complété → génération synthèse → affichage
  - [ ] 7.2 Tester la génération avec guide partiellement complété (catégories manquantes)
  - [ ] 7.3 Tester la regénération d'une synthèse existante
  - [ ] 7.4 Tester le stockage et la liaison avec la property

- [ ] Task 8 : Validation finale (AC: #1)
  - [ ] 8.1 Vérifier que la synthèse est générée côté client sans appel backend
  - [ ] 8.2 Vérifier que la synthèse est stockée localement via Drift
  - [ ] 8.3 Vérifier que la synthèse est liée correctement à la fiche annonce
  - [ ] 8.4 Vérifier que le recap par catégorie est clair et structuré
  - [ ] 8.5 Commit : `git add . && git commit -m "feat: génération synthèse post-visite côté client"`

## Dev Notes

### Architecture & Contraintes

- **Client-only logic** : La génération de la synthèse se fait entièrement côté client (Flutter), sans backend. Le backend n'expose pas d'endpoint dédié pour cette feature [Source: architecture.md#Requirements → Structure Mapping, ligne "Synthèse post-visite : — (client-only)"]
- **Drift storage** : La synthèse est stockée dans la table `post_visit_summaries` via Drift. Elle est marquée pour sync même si le backend ne l'utilise pas directement [Source: architecture.md#Data Architecture]
- **Agrégation par catégorie** : Le service doit parcourir les réponses du guide de visite (stockées dans `visit_guides_table`) et générer un récapitulatif par catégorie (structure, électricité, plomberie, toiture, isolation, division, extérieurs, environnement) [Source: epics.md#Story 5.1, ligne "les catégories s'affichent"]
- **Logique embarquée** : Utiliser des règles de détection de patterns pour identifier les points remarquables dans les réponses et générer un texte synthétique

### Versions techniques confirmées

- **Drift** : dernière version stable — pour le stockage local de la synthèse
- **uuid** : ^4.0.0 — génération des IDs de synthèse
- **intl** : pour formatage des dates

### Structure de summary_data JSON

```json
{
  "categories": [
    {
      "name": "structure",
      "summary": "État général bon. Fissures mineures détectées en façade.",
      "highlights": ["Fissures façade", "Fondations saines"]
    },
    {
      "name": "electricite",
      "summary": "Installation vétuste, tableau non aux normes.",
      "highlights": ["Tableau à remplacer", "Prises non reliées à la terre"]
    }
  ],
  "generated_at": "2026-01-27T14:30:00Z",
  "based_on_responses": 42
}
```

### Commandes de génération

Le `PostVisitSummaryService` doit implémenter :

```dart
class PostVisitSummaryService {
  Future<PostVisitSummary> generateSummary(String propertyId) async {
    // 1. Récupérer les réponses du guide via VisitGuideRepository
    // 2. Grouper par catégorie
    // 3. Analyser chaque catégorie et générer un résumé textuel
    // 4. Créer le JSON summary_data
    // 5. Retourner un PostVisitSummary avec UUID généré
  }
}
```

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   ├── core/
│   │   └── db/
│   │       └── tables/
│   │           └── post_visit_summaries_table.dart   # Nouvelle table
│   ├── features/
│   │   └── post_visit_summary/                       # Nouvelle feature
│   │       ├── data/
│   │       │   ├── post_visit_summary_repository.dart
│   │       │   ├── post_visit_summary_local_source.dart
│   │       │   ├── post_visit_summary_service.dart   # Logique génération
│   │       │   └── models/
│   │       │       └── post_visit_summary_model.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── post_visit_summary_cubit.dart
│   │           │   └── post_visit_summary_state.dart
│   │           ├── pages/
│   │           │   └── post_visit_summary_page.dart
│   │           └── widgets/
│   │               └── summary_category_card.dart
└── test/
    └── features/
        └── post_visit_summary/
            ├── data/
            │   ├── post_visit_summary_repository_test.dart
            │   └── post_visit_summary_service_test.dart
            └── presentation/
                └── cubit/
                    └── post_visit_summary_cubit_test.dart
```

### References

- [Source: architecture.md#Requirements → Structure Mapping] — Synthèse post-visite est client-only (pas de backend)
- [Source: architecture.md#Data Architecture] — Drift storage, syncStatus pour marquage
- [Source: epics.md#Epic 6 : Synthèse Post-visite] — Description fonctionnelle complète
- [Source: epics.md#Story 6.1] — Acceptance criteria BDD, génération automatique
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit, folder-by-feature
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Naming conventions Dart

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
