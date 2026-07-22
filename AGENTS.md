# AGENTS.md — Laravel ERD Generator

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
- **Theme**: Material 3, deep indigo primary

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

- `lib/main.dart` — App bootstrap
- `lib/app.dart` — MaterialApp + navigation shell

## Conventions

- No comments unless explicitly requested
- Use `const` constructors wherever possible
- Prefer `final` for local variables
- Trailing commas for multi-line parameter lists
- Single quotes preferred (enforced by linter)
- ConsumerWidget for Riverpod-connected widgets, StatelessWidget otherwise

## Critical Gotchas

1. **Freezed codegen**: After modifying any model with `@freezed`, you MUST run `dart run build_runner build --delete-conflicting-outputs` before testing or analyzing
2. **Commit conventions**: Use conventional commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`)
3. **One feature per commit**: Keep commits focused on a single feature or fix
