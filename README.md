# Lumina ERD Studio

A desktop & mobile application that analyzes Laravel projects and generates interactive Entity Relationship Diagrams.

## Features

- **Project Loader** — Select any Laravel project directory; auto-detects migrations and models
- **Schema Viewer** — Browse tables with search, sort, column details, and relationship badges
- **ERD Canvas** — Interactive diagram with drag, zoom, grid & force-directed layouts
- **Export Engine** — 6 formats: Mermaid, DBML, HTML (interactive SVG), Markdown, PlantUML, Graphviz
- **Onboarding** — 3-screen intro for first-time users
- **Settings** — Configure parsing, display, export defaults, and data management
- **Accessibility** — Screen reader labels, keyboard navigation, scalable text

## Screenshots

```
┌─────────────────────────────────────────────┐
│  Lumina ERD Studio                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ Select  │→ │ Schema  │→ │   ERD   │     │
│  │ Project │  │ Viewer  │  │ Canvas  │     │
│  └─────────┘  └─────────┘  └─────────┘     │
│         ↓                                   │
│    Export (Mermaid / DBML / HTML / ...)     │
└─────────────────────────────────────────────┘
```

## Requirements

- Flutter SDK 3.11.3+
- Dart SDK 3.11.3+
- Android SDK (for Android builds)
- Xcode (for iOS/macOS builds)

## Quick Start

```bash
# Clone
git clone https://github.com/your-org/lumina_erd_generator.git
cd lumina_erd_generator

# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

Or use the Makefile:

```bash
make build-android
make build-ios
make build-macos
make build-windows
make build-linux
```

## Project Structure

```
lib/
├── main.dart                              # Entry point
├── app.dart                               # MaterialApp + navigation shell
├── core/
│   ├── constants/app_constants.dart
│   ├── errors/app_exceptions.dart         # Custom exception hierarchy
│   ├── errors/error_handler.dart          # User-friendly error messages
│   ├── services/config_service.dart       # SharedPreferences persistence
│   ├── services/parse_cache.dart          # LRU cache for parsed results
│   ├── theme/app_theme.dart               # Material 3 light/dark themes
│   └── utils/
│       ├── debouncer.dart                 # Search debouncing
│       ├── file_utils.dart
│       └── string_utils.dart
├── features/
│   ├── onboarding/                        # 3-screen intro flow
│   ├── project_loader/                    # Directory picker + validation + parsing orchestration
│   ├── schema_parser/                     # Data models (Freezed) + migration/model parsers + UI
│   ├── erd_viewer/                        # Interactive canvas + table nodes + relationship lines
│   ├── export/                            # 6 exporters + preview + share
│   └── settings/                          # App configuration UI
└── shared/
    └── widgets/
        ├── accessible_widgets.dart        # Semantics + keyboard navigation
        ├── page_transitions.dart          # Fade + slide-up transitions
        └── skeleton_loader.dart           # Shimmer loading skeletons
```

## Architecture

- **State Management**: Riverpod (StateNotifier + Provider)
- **Data Models**: Freezed (immutable, with JSON serialization)
- **Design**: Material 3 with deep indigo primary color
- **Architecture Pattern**: Feature-first clean architecture

## How It Works

1. **Select a Laravel project** — The app validates `artisan` exists, scans `database/migrations/` and `app/Models/`
2. **Parse** — Regex-based parsers extract table schemas, column definitions, foreign keys, and relationships
3. **Visualize** — Tables rendered as draggable cards; relationships as connector lines
4. **Export** — Choose from 6 output formats; copy to clipboard or save to file

## Testing

```bash
# Unit tests (parsers, exporters)
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/

# All tests
flutter test
```

## Export Formats

| Format | Extension | Description |
|--------|-----------|-------------|
| Mermaid | `.md` | Mermaid diagram syntax, embeddable in Markdown |
| DBML | `.dbml` | Database Markup Language |
| HTML | `.html` | Interactive SVG diagram with zoom/pan |
| Markdown | `.md` | Human-readable table documentation |
| PlantUML | `.puml` | UML diagram syntax |
| Graphviz | `.dot` | Graphviz DOT language |

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
