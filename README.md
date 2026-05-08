# Lumi

Lumi is an anti-messaging Flutter app for close family and inner circle relationships. Instead of composing text, people send low-friction presence signals: a glow, a pulse, a one-stroke doodle, or a color.

This repository contains the Flutter client for the first Lumi vertical slice:

- OTP-style onboarding flow with a demo-safe fallback
- profile setup with signature color and avatar style
- 12-slot family circle home
- invite and paywall flows
- Pure Lumi and Light Lumi send/receive/reaction loop
- quiet hours, Kept Shelf, and settings scaffolding

## Architecture

The app follows feature-first Clean Architecture:

```text
lib/
├── core/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── profile/
│   ├── circle/
│   ├── lumi/
│   ├── settings/
│   ├── shelf/
│   ├── subscription/
│   ├── presence/
│   └── rituals/
├── l10n/
├── app.dart
├── bootstrap.dart
├── main.dart
├── main_development.dart
└── main_production.dart
```

Core stack:

- `flutter_bloc`
- `get_it`
- `dartz`
- `supabase_flutter`
- `purchases_flutter`
- `flutter_dotenv`
- `flutter_local_notifications`
- `firebase_messaging`
- `cryptography`
- `flutter_secure_storage`
- `home_widget`

<<<<<<< HEAD
=======
The current sample orb implementation lives in:

- `lib/features/circle/presentation/widgets/member_orb.dart`

It uses the shared design tokens and serves as the reference “soft glow” widget for the app shell.

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
## Environment setup

Environment values are loaded through `EnvironmentConfig` using this fallback order:

1. `assets/env/.env.development` or `assets/env/.env.production`
2. `assets/env/.env`
3. `assets/env/.env.example`

The repo ships with demo-friendly env files so the app can run without real backend credentials.

### Demo mode

Demo mode is enabled by default in the committed env files.

When demo mode is enabled:

- auth uses a local OTP simulation
- the app boots without real Supabase keys
- local repositories seed enough state to exercise Lumi flows

To connect real services, set:

- `ENABLE_DEMO_MODE=false`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `REVENUECAT_APPLE_KEY`
- `REVENUECAT_GOOGLE_KEY`

## Install dependencies

```bash
flutter pub get
dart run build_runner build
```

## Run the app

Development entrypoint:

```bash
flutter run -t lib/main_development.dart
```

Production entrypoint:

```bash
flutter run -t lib/main_production.dart
```

Default entrypoint:

```bash
flutter run
```

## Flavors and platform identifiers

Android:

- namespace: `dev.gauss.lumi`
- development application id: `dev.gauss.lumi.dev`
- production application id: `dev.gauss.lumi`

iOS:

- development bundle id: `dev.gauss.lumi.dev`
- production bundle id: `dev.gauss.lumi`

These are placeholders for the current implementation pass and can be replaced with final shipping identifiers later.

## Validation

Generate code:

```bash
dart run build_runner build
```

Analyze:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

<<<<<<< HEAD
=======
Optional flavor generator sync:

```bash
dart run flutter_flavorizr
```

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
## Platform notes

- Android manifest includes notification, vibration, contacts, and home widget background hooks.
- iOS `Info.plist` includes notification, contacts, and camera usage descriptions plus background modes for remote notifications and fetch.
- `AppDelegate.swift` contains `home_widget` background registration scaffolding for future interactive widget work.

## Known environment note

Linux desktop builds may require additional linker/toolchain setup depending on the VM image. Web and test/analyze workflows are the most reliable local verification paths in minimal environments.
<<<<<<< HEAD
=======

CI is configured in `.github/workflows/flutter_ci.yml` to run:

- `dart run build_runner build`
- `flutter analyze`
- `flutter test`
- `flutter build web --target lib/main_development.dart`
- `flutter build web --target lib/main_production.dart`
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
