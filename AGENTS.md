# AGENTS.md — Lumina ERD Generator

## Project Overview

Flutter desktop & mobile app that analyzes Laravel projects and generates interactive Entity Relationship Diagrams. Feature-first clean architecture using Riverpod + Freezed.

## Key Commands

```bash
# Required after any Freezed model changes
dart run build_runner build --delete-conflicting-outputs

# Or watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Verify code quality (run in this order)
dart format .
flutter analyze
flutter test

# Focused test suites
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/

# Makefile shortcuts
make gen          # code generation
make analyze      # flutter analyze
make test         # all tests
make test-unit    # unit tests only
```

## Architecture

- **Pattern**: Feature-first clean architecture
- **State Management**: Riverpod (StateNotifier + Provider)
- **Models**: Freezed (immutable, with JSON serialization)
- **Theme**: Material 3, deep indigo primary (`#303F9F`)

### Feature Modules (`lib/features/`)

| Feature | Purpose |
|---------|---------|
| `onboarding/` | 3-screen intro for first-time users |
| `project_loader/` | Directory picker, validation, parsing orchestration |
| `schema_parser/` | Data models (Freezed) + migration/model parsers + UI |
| `erd_viewer/` | Interactive canvas + table nodes + relationship lines |
| `export/` | 6 exporters + preview + share |
| `settings/` | App configuration UI |

### Entry Points

- `lib/main.dart` — App bootstrap + `MainShell` (the real app)
- `lib/app.dart` — Dead duplicate of `main.dart`'s `LuminaErdApp` + `MainShell` + `currentIndexProvider`

## Conventions

- No comments unless explicitly requested
- Use `const` constructors wherever possible
- Prefer `final` for local variables
- Trailing commas for multi-line parameter lists
- Single quotes preferred (enforced by linter)
- ConsumerWidget for Riverpod-connected widgets, StatelessWidget otherwise

## Critical Gotchas

1. **Freezed codegen**: After modifying any model with `@freezed`, you MUST run `dart run build_runner build --delete-conflicting-outputs` before testing or analyzing. Freezed produces both `.freezed.dart` and `.g.dart` files (the latter from `json_serializable`).
2. **`lib/app.dart` is dead code**: `main.dart` redefines `currentIndexProvider`, `LuminaErdApp`, and `MainShell` inline. `app.dart` is never imported by production code, but test files (`test/widget_test.dart`, `test/widget/erd_viewer_test.dart`) import it. Both files define `currentIndexProvider` at the top level — importing both would cause a compile error.
3. **Integration test path**: Integration tests live at `test/integration/`, not `integration_test/`. The Makefile has no integration test target — run with `flutter test test/integration/`.
4. **Unit tests create temp directories**: Parser tests write to `Directory.systemTemp.createTempSync()` and clean up after. They require filesystem access (no mocking).
5. **ERD Viewer**: `relationship_line.dart` uses `CustomPainter` with bezier curves, obstacle avoidance via `LineSegment` intersection detection, and color-coding by relationship type via `AppColors` theme extension. `erd_canvas.dart` passes obstacle rects (all non-selected table positions) to avoid line overlap.
6. **Relationship colors**: Defined in `AppColors` theme extension (`lib/core/theme/app_colors.dart`). `belongsTo` = foreignKey (orange), `hasMany` = explicitRelation (indigo), `hasOne` = info (blue), `belongsToMany` = pivotKey (yellow).
