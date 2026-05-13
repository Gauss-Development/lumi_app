# Lumi — development Makefile
# Common shortcuts for the development flavor. `make help` for a list.
# Override defaults with FLAVOR=production or DEVICE=<deviceId>.

FLAVOR ?= development
ENTRY  := lib/main_$(FLAVOR).dart
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)

.PHONY: help setup run run-prod build-apk build-apk-release build-ios \
        build-ios-release clean pubget pods gen watch test analyze format \
        provision doctor

help: ## Show this help
	@awk -F ':.*##' '/^[a-zA-Z_][a-zA-Z0-9_-]*:.*##/ {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: pubget pods gen ## First-time setup: deps + iOS pods + codegen

run: ## Run the app (FLAVOR=production for prod; DEVICE=<id> to pin a device)
	flutter run --flavor $(FLAVOR) -t $(ENTRY) $(DEVICE_ARG)

run-prod: ## Shortcut for `FLAVOR=production make run`
	$(MAKE) run FLAVOR=production

build-apk: ## Build a debug APK for the current flavor
	flutter build apk --debug --flavor $(FLAVOR) -t $(ENTRY)

build-apk-release: ## Build a release APK (uses debug signing per build.gradle.kts)
	flutter build apk --release --flavor $(FLAVOR) -t $(ENTRY)

build-ios: ## Build the iOS app (debug, no codesign)
	flutter build ios --debug --flavor $(FLAVOR) -t $(ENTRY) --no-codesign

build-ios-release: ## Build the iOS app (release, no codesign — archive in Xcode)
	flutter build ios --release --flavor $(FLAVOR) -t $(ENTRY) --no-codesign

clean: ## flutter clean
	flutter clean

pubget: ## flutter pub get
	flutter pub get

pods: ## Reinstall iOS CocoaPods
	cd ios && pod install --repo-update

gen: ## Run build_runner once (freezed, json_serializable, …)
	dart run build_runner build

watch: ## Run build_runner in watch mode
	dart run build_runner watch

test: ## Run tests
	flutter test

analyze: ## Static analysis
	flutter analyze

format: ## Format Dart sources
	dart format lib test tool functions

provision: ## Provision the Appwrite schema (needs APPWRITE_PROVISIONING_API_KEY)
	@if [ -z "$$APPWRITE_PROVISIONING_API_KEY" ]; then \
		echo "APPWRITE_PROVISIONING_API_KEY is not set."; \
		echo "Create a server API key in Appwrite Console with"; \
		echo "  databases.read/write, collections.read/write,"; \
		echo "  attributes.read/write, indexes.read/write,"; \
		echo "  rows.read/write,"; \
		echo "  messages.write,"; \
		echo "  functions.read/write"; \
		echo "scopes, then run:"; \
		echo "  export APPWRITE_PROVISIONING_API_KEY=<key> && make provision"; \
		exit 1; \
	fi
	dart run tool/provision_appwrite.dart

deploy-functions: ## Deploy Appwrite Functions (needs APPWRITE_PROVISIONING_API_KEY)
	@if [ -z "$$APPWRITE_PROVISIONING_API_KEY" ]; then \
		echo "APPWRITE_PROVISIONING_API_KEY is not set."; \
		echo "Create a server API key with functions.read/write scopes."; \
		exit 1; \
	fi
	dart run tool/deploy_appwrite_functions.dart

doctor: ## flutter doctor -v
	flutter doctor -v
