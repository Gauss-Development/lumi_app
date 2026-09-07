# Supabase backend for Lumi

Lumi uses **Supabase** for auth, shared data, and server-side Lumi delivery.

## What lives in the remote database

| Table | Purpose |
|-------|---------|
| `profiles` | Display name, avatar style, signature color (synced across devices) |
| `circle_members` | Your circle connections, pace limits, mute/memorial state |
| `invitations` | Shareable invite codes and accept flow |
| `lumis` | Sent/received Lumi signals between users |
| `push_tokens` | FCM device tokens for push notifications |
| `presence_heartbeats` | Last app-open timestamp per user (together-moment detection) |

## What stays on-device only

These do **not** need a remote table for the current product:

| Data | Storage |
|------|---------|
| Settings (quiet hours, notifications, haptics) | SharedPreferences |
| Kept Shelf | SharedPreferences |
| Onboarding progress | SharedPreferences |
| Doodle drafts | SharedPreferences |
| Subscription cache | SharedPreferences + RevenueCat |
| Ritual preferences | SharedPreferences |
| Pending invite deep-link codes | SharedPreferences |
| Acknowledged reaction IDs | SharedPreferences |

Keeping settings and shelf local avoids sync complexity for single-device MVP flows. Add remote tables later if multi-device sync is required.

## Setup

1. Create a Supabase project and run the migration:

```bash
supabase db push
# or apply supabase/migrations/20260307000000_initial_schema.sql in the SQL editor
```

2. Deploy edge functions:

```bash
supabase functions deploy send_lumi
supabase functions deploy react_lumi
```

3. Set secrets for push (optional):

```bash
supabase secrets set FIREBASE_SERVER_KEY=<legacy-fcm-server-key>
```

4. Configure the Flutter app (`assets/env/.env.development`):

```
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=<anon-key>
OAUTH_REDIRECT_URL=io.supabase.lumi://login-callback/
```

5. Enable **Phone** and **Google** providers in Supabase Auth dashboard.

## Edge functions

- **`send_lumi`** — validates circle membership, pace limits (5/day/pair), creates `lumis` row, optional FCM push
- **`react_lumi`** — recipient-only reaction, updates lumi, optional FCM to sender

## RLS summary

- `profiles` — users read/update own row
- `circle_members` — owner CRUD on their rows
- `invitations` — authenticated read/update; inviter creates/deletes
- `lumis` — participants read; recipient updates (mark seen); inserts via edge function
- `push_tokens` — users manage own tokens
- `presence_heartbeats` — users upsert own row; circle members can read mutual connections' heartbeats

## Auth migration notes

| Appwrite | Supabase |
|----------|----------|
| `createEmailPasswordSession` | `signInWithPassword` |
| `createPhoneToken` + `createSession` | `signInWithOtp` + `verifyOTP` |
| `createOAuth2Session(google)` | `signInWithOAuth(google)` |
| `Account.createPushTarget` | `push_tokens` table |
