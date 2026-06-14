# Lumi — agent notes

## Cursor Cloud specific instructions

### Stack

Flutter app (Clean Architecture, `flutter_bloc`, Appwrite backend, RevenueCat). Server functions live under `functions/`.

### Commands

See `README.md` for the canonical dev workflow. Quick reference:

| Task | Command |
|------|---------|
| Dependencies | `flutter pub get` |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` |
| Analyze | `flutter analyze` |
| Tests | `flutter test` |
| Run (dev flavor) | `flutter run --flavor development -t lib/main_development.dart` |

Flutter SDK is expected on `PATH` (cloud VM: `$HOME/flutter/bin`).

### Push notifications (GAU-281)

- FCM is optional until Firebase env vars are set in `assets/env/.env.development` (or production): `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, optional `FIREBASE_IOS_BUNDLE_ID`, and `APPWRITE_FCM_PROVIDER_ID` for Appwrite Messaging.
- Without those values, the app still runs; delivery falls back to the existing 12s `LumiBloc` poll.
- `google-services.json` / `GoogleService-Info.plist` are not committed; native builds need them locally for real device push.
- Push registration runs after auth via `PushNotificationService.registerForAuthenticatedUser()`; sign-out calls `unregister()`.
- Incoming push taps must refresh with `recipientMemberId` (recipient-side circle member), not `senderMemberId`. `LumiBloc.watchRecent` always loads the full inbox; `memberId` on the event is UI focus only.

### Non-obvious gotchas

- Web: RevenueCat and FCM are skipped (`kIsWeb` guards).
- App router + blocs are created in `LumiApp`; push tap handling must stay inside `MultiBlocProvider` (see `_PushNotificationCoordinator`).
