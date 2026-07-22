#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Laravel ERD Studio — Build Script ==="
echo ""

# Check Flutter
if ! command -v flutter &>/dev/null; then
    echo "Error: Flutter not found. Install from https://flutter.dev"
    exit 1
fi

echo "Flutter version:"
flutter --version | head -1
echo ""

# Get dependencies
echo "Installing dependencies..."
flutter pub get
echo ""

# Run code generation
echo "Running code generation..."
dart run build_runner build --delete-conflicting-outputs
echo ""

# Analyze
echo "Analyzing code..."
flutter analyze
echo ""

# Run tests
echo "Running tests..."
flutter test
echo ""

# Build for current platform
PLATFORM="${1:-}"

case "$PLATFORM" in
    android|apk)
        echo "Building Android APK..."
        flutter build apk --release
        echo "Output: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    ios)
        echo "Building iOS..."
        flutter build ios --release
        ;;
    macos)
        echo "Building macOS..."
        flutter build macos --release
        ;;
    windows)
        echo "Building Windows..."
        flutter build windows --release
        ;;
    linux)
        echo "Building Linux..."
        flutter build linux --release
        ;;
    *)
        echo "No platform specified. Skipping build."
        echo "Usage: ./build.sh [android|ios|macos|windows|linux]"
        ;;
esac

echo ""
echo "Done!"
