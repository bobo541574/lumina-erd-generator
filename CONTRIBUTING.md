# Contributing to Lumina ERD Studio

Thank you for considering contributing to Lumina ERD Studio!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch: `git checkout -b feature/my-feature`
4. Install dependencies: `flutter pub get`
5. Run code generation: `dart run build_runner build`
6. Make your changes
7. Run tests: `flutter test`
8. Run analyzer: `flutter analyze`
9. Commit and push

## Development Setup

### Prerequisites

- Flutter SDK 3.11.3+
- Dart SDK 3.11.3+
- Android Studio / VS Code with Flutter extension

### Code Generation

This project uses Freezed for immutable models. After modifying any `*.freezed.dart` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Code Style

- Follow [Effective Dart](https://dart.dev/effective-dart) guidelines
- Use `const` constructors wherever possible
- Prefer `final` for local variables
- No comments unless requested
- Use trailing commas for multi-line parameter lists

### Architecture

- **Feature-first**: Each feature lives in `lib/features/<feature_name>/`
- **Separation**: `data/`, `domain/`, `presentation/` within each feature
- **Models**: Freezed classes in `domain/models/`
- **Providers**: Riverpod StateNotifier + Provider
- **Widgets**: Stateless where possible, ConsumerWidget for Riverpod

### Testing

- **Unit tests**: `test/unit/` — Parsers, exporters, utilities
- **Widget tests**: `test/widget/` — UI components
- **Integration tests**: `integration_test/` — Full workflows

Aim for tests on all new features and bug fixes.

### Commit Messages

Use conventional commits:

- `feat: Add new export format`
- `fix: Fix migration parser for nullable columns`
- `refactor: Extract common parsing logic`
- `test: Add tests for model parser`
- `docs: Update README`

## Pull Requests

1. Ensure all tests pass
2. Ensure `flutter analyze` reports no errors
3. Update README if adding user-facing features
4. Keep PRs focused — one feature or fix per PR
5. Write a clear PR description

## Reporting Issues

- Use GitHub Issues
- Include Flutter version (`flutter --version`)
- Include steps to reproduce
- Include expected vs actual behavior

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
