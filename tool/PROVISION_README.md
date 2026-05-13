# Appwrite Schema Provisioning

This script creates the Appwrite database `lumi`, all six collections used by
the app, and the `send_lumi` Function shell. It's idempotent — re-running skips
or updates anything that already exists.

## Collections

- **users** — `userId`, `email`, `name`, `displayName`, `avatarStyle`,
  `signatureColorValue`, `photoUrl`, `createdAt`
- **circle_members** — `ownerUserId` (indexed), `memberUserId`,
  `reciprocalMemberId`, `invitationCode`, `displayName`, `signatureColorValue`,
  `status`, `relationshipLabel`, `mutedUntil`, `paceCount`, `queuedCount`,
  `mutualConnection`, `subtitle`, `lastInteractionAt`, `createdAt`
- **invitations** — row id is the invite code. Fields: `inviterUserId`
  (indexed), `inviterDisplayName`, `inviterSignatureColorValue`,
  `inviteeLabel`, `inviteeRelationshipLabel`, `inviteeUserId`,
  `inviteeDisplayName`, `inviteeSignatureColorValue`, `inviterMemberId`,
  `inviteeMemberId`, `status`, `createdAt`, `expiresAt`, `acceptedAt`. Codes
  are 10-char alphanumeric (confusable-free), looked up by direct `getRow`,
  never listed.
- **lumis** — `senderId`, `recipientId`, `circleId`, `senderMemberId`,
  `recipientMemberId`, `type`, `colorValue`, `intensity`, `deliveryStatus`,
  `pulsePatternJson`, `doodleStrokeJson`, `seenAt`, `reactionEmoji`,
  `createdAt`
- **kept_lumis** — `userId`, `lumiId`, `keptAt`
- **settings** — `userId` (unique), `notificationsEnabled`, `hapticsEnabled`,
  `quietHoursEnabled`, `quietHoursStartHour/Minute`, `quietHoursEndHour/Minute`,
  `mutedMembers` (string array)

## How to run

### 1. Create a server API key

In Appwrite Console → your project → **Project Settings → API Keys → Create**.
Required scopes:

- `databases.read`, `databases.write`
- `collections.read`, `collections.write`
- `attributes.read`, `attributes.write`
- `indexes.read`, `indexes.write`
- `rows.read`, `rows.write`
- `messages.write`
- `functions.read`, `functions.write`

### 2. Run the script

```bash
APPWRITE_PROVISIONING_API_KEY=<your-server-key> dart run tool/provision_appwrite.dart
```

The key is read from the process environment so it never lands in a file.

### 3. Deploy Functions

```bash
APPWRITE_PROVISIONING_API_KEY=<your-server-key> dart run tool/deploy_appwrite_functions.dart
```

This uploads `functions/send_lumi` and activates the deployment. The Function
creates `lumis` rows server-side with strict sender/recipient permissions and
attempts an Appwrite Messaging push after the row is created.

### 4. Verify

In Appwrite Console → **Databases → lumi**, you should see the six collections
with their attributes and indexes. In **Functions**, `send_lumi` should be
enabled and have an active deployment.

## Notes

- Uses the **server SDK** `dart_appwrite` (under `dev_dependencies`), not the
  Flutter client SDK.
- Document-level security is on. Lumi delivery is server-side: the client calls
  `send_lumi`, and the Function writes the row with sender/recipient ACLs.
