
# ExoTrack Ultimate

**Tout-en-un**: générateur de programmes multi-sports, capteurs BLE (Polar H10 prêt; Movesense prêt à brancher), interface complète, règles YAML, et docs.

## Démarrage
```bash
flutter create .
flutter pub get
flutter run
```

## Capteurs
- **Polar H10**: service `Heart Rate (0x180D)` → mesure BPM, RR-interval → `TrainingLoad` interne.
- **Movesense Flash**: adapter prévu (UUIDs à compléter). Voir `lib/features/sensors/adapters/movesense_flash_adapter.dart`.

## Coach (règles YAML)
Fichiers dans `assets/data/rules/`. Cinq sports inclus: basketball, soccer, hockey, volleyball, football.
Le générateur lit la phase de saison, le niveau, le mix hebdo et assemble la semaine.

## YouTube
Chaque exercice peut avoir un lien YouTube associé. Player intégré (`youtube_player_iframe`).

## Structure
- `lib/core/` – thème, helpers
- `lib/features/coach/` – modèles, générateur, YAML loader
- `lib/features/sensors/` – BLE manager + adapters (Polar H10, Movesense Flash stub)
- `lib/features/workout/` – moteur de séance bi-mode (plan ↔ capteur)
- `lib/features/home/`, `history/`, `profile/` – UI
- `assets/data/rules/` – YAML sports
- `docs/` – QA (code / sport science / marketing)

## Licence
Usage interne / prototypage. À adapter.
