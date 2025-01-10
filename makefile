# Load environment variables from .env file
include .env
export

# Common dart define arguments
DART_DEFINES = --dart-define=API_BASE_URL=$(API_BASE_URL) \
               --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
               --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY)

.PHONY: run build-web build-ios build-apk clean

# Development
run:
	flutter run $(DART_DEFINES)

# Web
build-web:
	flutter build web --release $(DART_DEFINES)

run-web: 
	flutter run -d chrome $(DART_DEFINES)


serve-web: build-web
	cd build/web && python3 -m http.server 8000

# iOS
build-ios:
	flutter build ios --release $(DART_DEFINES)

# Android
build-apk:
	flutter build apk --release $(DART_DEFINES)

build-appbundle:
	flutter build appbundle --release $(DART_DEFINES)

# Utility commands
clean:
	flutter clean
	flutter pub get

get: 
	flutter pub get

format:
	dart format lib/

analyze:
	flutter analyze

test:
	flutter test

# Combined commands
build-all: build-web build-ios build-apk build-appbundle

# Install dependencies
setup:
	flutter pub get
	flutter clean
