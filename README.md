# CoachPulse MVP V1 (Flutter + Supabase)

Dépôt prêt à compiler pour Android (Google Play) avec architecture claire:

- `apps/flutter_app`: application Flutter (Riverpod, go_router, freezed/json, intl fr-CA/en, Material 3)
- `supabase/migrations`: SQL de création des tables/index
- `supabase/policies`: SQL RLS strict coach/client
- `supabase/seed`: seed minimal de démonstration
- `.env.example`: variables d’environnement requises

## 1) Prérequis

- Flutter stable (`flutter --version`)
- Android Studio + SDK Android + émulateur
- Compte Supabase
- Supabase CLI optionnel (`npm i -g supabase`)

## 2) Créer le projet Supabase

1. Créez un projet Supabase.
2. Récupérez:
   - `Project URL`
   - `anon public key`
3. Activez l’auth Email/Password dans **Authentication > Providers**.

## 3) Appliquer migrations + policies + seed

Option SQL Editor Supabase:

1. Exécuter `supabase/migrations/001_init.sql`
2. Exécuter `supabase/policies/001_rls.sql`
3. Exécuter `supabase/seed/001_seed.sql`

Option CLI:

```bash
supabase db push
psql "$SUPABASE_DB_URL" -f supabase/policies/001_rls.sql
psql "$SUPABASE_DB_URL" -f supabase/seed/001_seed.sql
```

## 4) Configurer Flutter

```bash
cp .env.example apps/flutter_app/.env
```

Remplir les valeurs réelles dans `apps/flutter_app/.env`:

```env
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
```

Puis:

```bash
cd apps/flutter_app
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

## 5) Lancer en debug Android

```bash
cd apps/flutter_app
flutter run -d android
```

## 6) Build APK debug

```bash
cd apps/flutter_app
flutter build apk --debug
```

APK généré dans `apps/flutter_app/build/app/outputs/flutter-apk/app-debug.apk`.

## 7) MVP inclus

- Auth email/password
- Structure rôle COACH/CLIENT
- Écran login + navigation principale (`Today`, `Calendar`, `Dashboard`, `Privacy`)
- Base repository Supabase (auth/exercises/sessions)
- Dashboard coach (graph simple `fl_chart`)
- Écran confidentialité (export JSON local + suppression soft-delete à brancher)
- i18n fr-CA/en
- Tests unit/widget de base

## 8) Checklist Play Console (MVP)

- Privacy Policy URL publique
- Formulaire Data Safety complété (auth + données santé/performance)
- Déclaration app santé/fitness selon usage
- Disclaimer non médical affiché dans l’app

## 9) Guide rapide: ajouter un nouvel écran/module (V2)

1. Créer `lib/features/<module>/<module>_page.dart`
2. Ajouter route dans `lib/core/app_router.dart`
3. Ajouter repository/DTO dans `lib/data/...`
4. Créer modèle `freezed` si nécessaire
5. Générer code:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
6. Ajouter tests dans `test/`

## 10) Notes produit MVP

- L’invitation coach->client est conçue via table `coach_client_links.invite_code`.
- Génération calendrier et analytics avancés peuvent être enrichis via SQL views + Edge Functions sur V2.
