# AGENTS.md

## Cursor Cloud specific instructions

### Product

Lumi is a single Flutter client (`lib/`) backed by hosted **Appwrite Cloud** (`https://sfo.cloud.appwrite.io/v1`, project `69ff68eb0033441e4041`). There is no in-repo backend server. Optional Appwrite provisioning lives under `tool/`.

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
| Appwrite schema | `export APPWRITE_PROVISIONING_API_KEY=<key> && make provision` |
| Deploy functions | `export APPWRITE_PROVISIONING_API_KEY=<key> && make deploy-functions` |

Full Makefile targets: `make help`.

### Web runtime

`flutter build web` and `flutter run -d web-server --web-port=8080 -t lib/main_development.dart` work in cloud VMs after `RevenueCatService` avoids `dart:io` `Platform` on web (`kIsWeb` guard).

Auth/sign-up against Appwrite requires network access to `https://sfo.cloud.appwrite.io`. Without valid credentials the UI still loads to the login screen.

### Linux desktop

`flutter build linux` may fail in minimal Ubuntu images (missing `libstdc++` linker paths for clang, `webkit2gtk`, C++ header paths). Web build + tests are the supported cloud verification path per `README.md`.

### Environment files

Loaded from `assets/env/.env.development` (dev) or `.env.production` via `EnvironmentConfig`. Appwrite endpoint/project ID are hardcoded in `lib/core/network/appwrite_client.dart`.

### Backend for real E2E (auth, circle, send Lumi)

Requires a provisioned Appwrite project and deployed `send_lumi` function — see `tool/PROVISION_README.md`. Not needed for `flutter test` / `flutter analyze`.
