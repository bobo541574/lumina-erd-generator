.PHONY: help clean get test analyze build-android build-ios build-macos build-windows build-linux run format

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## Clean build artifacts
	flutter clean

get: ## Get dependencies
	flutter pub get

gen: ## Run code generation
	dart run build_runner build --delete-conflicting-outputs

gen-watch: ## Watch for code generation changes
	dart run build_runner watch --delete-conflicting-outputs

test: ## Run all tests
	flutter test

test-unit: ## Run unit tests only
	flutter test test/unit/

test-widget: ## Run widget tests only
	flutter test test/widget/

analyze: ## Analyze code
	flutter analyze

format: ## Format code
	dart format .

run: ## Run in debug mode
	flutter run

build-android: ## Build Android APK
	flutter build apk --release

build-ios: ## Build iOS
	flutter build ios --release

build-macos: ## Build macOS
	flutter build macos --release

build-windows: ## Build Windows
	flutter build windows --release

build-linux: ## Build Linux
	flutter build linux --release

doctor: ## Check Flutter environment
	flutter doctor
