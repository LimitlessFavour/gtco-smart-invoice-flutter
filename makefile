# Load environment variables from .env file
include .env
export

# Common dart define arguments
DART_DEFINES = --dart-define=API_BASE_URL=$(API_BASE_URL) \
               --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
               --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY)

.PHONY: run build-web build-ios build-apk clean


run-ipad-simulator:
	flutter run -d 75709168-4555-4841-A49A-923B7573961F --dart-define-from-file=.env.development lib/main.dart
# flutter run -d 75709168-4555-4841-A49A-923B7573961F --dart-define-from-file=.env.production lib/main.dart

# Development
run:
	flutter run --dart-define-from-file=.env.development lib/main.dart

# Web
build-web:
	cp .env.production .env
	flutter build web --release --dart-define-from-file=.env
# flutter build web --release $(DART_DEFINES)

run-web:	
	cp .env.development .env
	flutter run -d chrome --dart-define-from-file=.env
#   flutter run -d chrome $(DART_DEFINES)


serve-web: build-web
	cd build/web && python3 -m http.server 8000

# iOS
build-ios:
	flutter build ios --release $(DART_DEFINES)

build-ios-simulator:
	flutter build ios $(DART_DEFINES)

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
