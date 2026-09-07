# AGENTS.md

## Cursor Cloud specific instructions

### Product

Lumi is a single Flutter client (`lib/`) backed by **Supabase** (Auth, Postgres, Edge Functions). There is no in-repo backend server. Schema and edge functions live under `supabase/`. See `tool/SUPABASE_README.md`.

### Flutter SDK

Flutter is **not** vendored in the repo. The VM installs stable Flutter to `$HOME/flutter`; `~/.bashrc` prepends `$HOME/flutter/bin` to `PATH`. Run `flutter doctor -v` after setup if commands fail.

### First-time / daily dependency refresh

See the VM update script (runs automatically on agent startup):

```bash
flutter pub get
dart run build_runner build
```

Do **not** run `make setup` on Linux cloud VMs — it always runs `make pods` (iOS CocoaPods), which is unnecessary here and may fail without macOS.

### Common commands

| Task | Command |
|------|---------|
| Install deps | `make pubget` or `flutter pub get` |
| Codegen (freezed/json) | `make gen` or `dart run build_runner build` |
| Lint | `make analyze` or `flutter analyze` |
| Tests | `make test` or `flutter test` |
| Run (mobile flavor) | `make run` — needs Android/iOS device or emulator |
| Web build (CI parity) | `flutter build web --target lib/main_development.dart` |
| Apply DB schema | `supabase db push` (see `tool/SUPABASE_README.md`) |
| Deploy edge functions | `make deploy-functions` |

Full Makefile targets: `make help`.

### Web runtime

`flutter build web` and `flutter run -d web-server --web-port=8080 -t lib/main_development.dart` work in cloud VMs after `RevenueCatService` avoids `dart:io` `Platform` on web (`kIsWeb` guard).

Auth/sign-up against Supabase requires `SUPABASE_URL` and `SUPABASE_ANON_KEY` in env files. Without valid credentials the UI still loads to the login screen.

### Linux desktop

`flutter build linux` may fail in minimal Ubuntu images (missing `libstdc++` linker paths for clang, `webkit2gtk`, C++ header paths). Web build + tests are the supported cloud verification path per `README.md`.

### Environment files

Loaded from `assets/env/.env.development` (dev) or `.env.production` via `EnvironmentConfig`. Required for production: `SUPABASE_URL`, `SUPABASE_ANON_KEY`.

### Backend for real E2E (auth, circle, send Lumi)

Requires a provisioned Supabase project with schema migration applied and edge functions deployed — see `tool/SUPABASE_README.md`. Not needed for `flutter test` / `flutter analyze`.
