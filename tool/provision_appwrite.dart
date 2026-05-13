// Idempotent Appwrite provisioning for the Lumi project.
//
// Run with:
//   APPWRITE_PROVISIONING_API_KEY=<server-api-key> dart run tool/provision_appwrite.dart
//
// The API key needs scopes: databases.read, databases.write,
// collections.read, collections.write, attributes.read, attributes.write,
// indexes.read, indexes.write, functions.read, functions.write.
//
// Re-running is safe: every step skips on 409 (already exists).

import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart' as enums;
import 'package:dart_appwrite/models.dart' as models;

const String _projectId = '69ff68eb0033441e4041';
const String _endpoint = 'https://sfo.cloud.appwrite.io/v1';
const String _databaseId = 'lumi';
const String _databaseName = 'Lumi';

late final Databases databases;
late final Functions functions;

Future<void> main() async {
  final String? apiKey = Platform.environment['APPWRITE_PROVISIONING_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      'APPWRITE_PROVISIONING_API_KEY env var is required.\n'
      'Create a server API key in Appwrite Console (Project Settings → API Keys)\n'
      'with databases.read & databases.write scopes, then run:\n'
      '  APPWRITE_PROVISIONING_API_KEY=<key> dart run tool/provision_appwrite.dart',
    );
    exit(1);
  }

  final Client client = Client()
      .setEndpoint(_endpoint)
      .setProject(_projectId)
      .setKey(apiKey);
  databases = Databases(client);
  functions = Functions(client);

  await _ensureDatabase();

  await _provisionUsers();
  await _provisionCircleMembers();
  await _provisionInvitations();
  await _provisionLumis();
  await _provisionKeptLumis();
  await _provisionSettings();
  await _provisionSendLumiFunction();

  stdout.writeln('\nProvisioning complete.');
}

Future<void> _provisionSendLumiFunction() async {
  const String id = 'send_lumi';
  const String name = 'Send Lumi';
  const List<String> execute = <String>['users'];
  const List<String> scopes = <String>[
    'databases.read',
    'databases.write',
    'rows.read',
    'rows.write',
    'messages.write',
  ];

  try {
    await functions.create(
      functionId: id,
      name: name,
      runtime: enums.Runtime.dart35,
      execute: execute,
      timeout: 15,
      enabled: true,
      logging: true,
      entrypoint: 'lib/main.dart',
      commands: 'dart pub get',
      scopes: scopes,
    );
    stdout.writeln('+ function $id');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '= function $id');
    await functions.update(
      functionId: id,
      name: name,
      runtime: enums.Runtime.dart35,
      execute: execute,
      timeout: 15,
      enabled: true,
      logging: true,
      entrypoint: 'lib/main.dart',
      commands: 'dart pub get',
      scopes: scopes,
    );
    stdout.writeln('  ~ function $id config');
  }

  await _ensureFunctionVariable(id, 'APPWRITE_ENDPOINT', _endpoint);
}

Future<void> _ensureFunctionVariable(
  String functionId,
  String key,
  String value,
) async {
  final models.VariableList variables = await functions.listVariables(
    functionId: functionId,
  );
  for (final models.Variable variable in variables.variables) {
    if (variable.key == key) {
      await functions.updateVariable(
        functionId: functionId,
        variableId: variable.$id,
        key: key,
        value: value,
      );
      stdout.writeln('  ~ function $functionId env $key');
      return;
    }
  }

  await functions.createVariable(
    functionId: functionId,
    key: key,
    value: value,
  );
  stdout.writeln('  + function $functionId env $key');
}

// ---------------- Collections ----------------

Future<void> _provisionUsers() async {
  const String id = 'users';
  await _ensureCollection(id, 'Users', <String>[
    Permission.create(Role.users()),
    Permission.read(Role.users()),
  ]);
  await _ensureStringAttr(id, 'userId', size: 64, required: true);
  await _ensureStringAttr(id, 'email', size: 320, required: true);
  await _ensureStringAttr(id, 'name', size: 128);
  await _ensureStringAttr(id, 'displayName', size: 128);
  await _ensureStringAttr(id, 'avatarStyle', size: 64);
  await _ensureIntAttr(id, 'signatureColorValue');
  await _ensureStringAttr(id, 'photoUrl', size: 1024);
  await _ensureDatetimeAttr(id, 'createdAt', required: true);
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_userId', enums.IndexType.unique, <String>[
    'userId',
  ]);
  await _ensureIndex(id, 'idx_email', enums.IndexType.unique, <String>[
    'email',
  ]);
}

Future<void> _provisionCircleMembers() async {
  const String id = 'circle_members';
  await _ensureCollection(id, 'Circle Members', <String>[
    Permission.create(Role.users()),
  ]);
  await _ensureStringAttr(id, 'ownerUserId', size: 64, required: true);
  await _ensureStringAttr(id, 'memberUserId', size: 64);
  await _ensureStringAttr(id, 'reciprocalMemberId', size: 64);
  await _ensureStringAttr(id, 'invitationCode', size: 32);
  await _ensureStringAttr(id, 'displayName', size: 128, required: true);
  await _ensureIntAttr(id, 'signatureColorValue', required: true);
  await _ensureStringAttr(id, 'status', size: 32, required: true);
  await _ensureStringAttr(id, 'relationshipLabel', size: 64);
  await _ensureDatetimeAttr(id, 'mutedUntil');
  await _ensureIntAttr(id, 'paceCount');
  await _ensureIntAttr(id, 'queuedCount');
  await _ensureBoolAttr(id, 'mutualConnection');
  await _ensureStringAttr(id, 'subtitle', size: 256);
  await _ensureDatetimeAttr(id, 'lastInteractionAt');
  await _ensureDatetimeAttr(id, 'createdAt', required: true);
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_ownerUserId', enums.IndexType.key, <String>[
    'ownerUserId',
  ]);
  await _ensureIndex(id, 'idx_memberUserId', enums.IndexType.key, <String>[
    'memberUserId',
  ]);
  await _ensureIndex(id, 'idx_invitationCode', enums.IndexType.key, <String>[
    'invitationCode',
  ]);
}

Future<void> _provisionInvitations() async {
  const String id = 'invitations';
  // Only `create` is granted at the collection level. Per-row perms set at
  // create time grant `read`/`update` to all authenticated users so the
  // invitee can look up by row id (the code) and mark accepted. Codes are
  // long enough that direct `getRow` lookup is not enumerable.
  await _ensureCollection(id, 'Invitations', <String>[
    Permission.create(Role.users()),
  ]);
  await _ensureStringAttr(id, 'inviterUserId', size: 64, required: true);
  await _ensureStringAttr(id, 'inviterDisplayName', size: 128, required: true);
  await _ensureIntAttr(id, 'inviterSignatureColorValue', required: true);
  await _ensureStringAttr(id, 'inviteeLabel', size: 128, required: true);
  await _ensureStringAttr(id, 'inviteeRelationshipLabel', size: 64);
  await _ensureStringAttr(id, 'inviteeUserId', size: 64);
  await _ensureStringAttr(id, 'inviteeDisplayName', size: 128);
  await _ensureIntAttr(id, 'inviteeSignatureColorValue');
  await _ensureStringAttr(id, 'inviterMemberId', size: 64);
  await _ensureStringAttr(id, 'inviteeMemberId', size: 64);
  await _ensureStringAttr(id, 'status', size: 32, required: true);
  await _ensureDatetimeAttr(id, 'createdAt', required: true);
  await _ensureDatetimeAttr(id, 'expiresAt', required: true);
  await _ensureDatetimeAttr(id, 'acceptedAt');
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_inviterUserId', enums.IndexType.key, <String>[
    'inviterUserId',
  ]);
}

Future<void> _provisionLumis() async {
  const String id = 'lumis';
  // Pulse and doodle payloads are stored as bounded JSON strings for now.
  // Larger rich payloads should move to Appwrite Storage as file references.
  await _ensureCollection(id, 'Lumis', <String>[
    Permission.create(Role.users()),
  ]);
  await _ensureStringAttr(id, 'senderId', size: 64, required: true);
  await _ensureStringAttr(id, 'recipientId', size: 64, required: true);
  await _ensureStringAttr(id, 'circleId', size: 64);
  await _ensureStringAttr(id, 'senderMemberId', size: 64);
  await _ensureStringAttr(id, 'recipientMemberId', size: 64);
  await _ensureStringAttr(id, 'type', size: 32, required: true);
  await _ensureIntAttr(id, 'colorValue');
  await _ensureFloatAttr(id, 'intensity');
  await _ensureStringAttr(id, 'deliveryStatus', size: 32);
  await _ensureStringAttr(id, 'pulsePatternJson', size: 2048);
  // 32768 trips Appwrite into TEXT (external) storage, so the row stays
  // under MariaDB's varchar row-size limit even with everything else here.
  await _ensureStringAttr(id, 'doodleStrokeJson', size: 32768);
  await _ensureDatetimeAttr(id, 'seenAt');
  await _ensureStringAttr(id, 'reactionEmoji', size: 16);
  await _ensureDatetimeAttr(id, 'createdAt', required: true);
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_senderId', enums.IndexType.key, <String>[
    'senderId',
  ]);
  await _ensureIndex(id, 'idx_recipientId', enums.IndexType.key, <String>[
    'recipientId',
  ]);
  await _ensureIndex(id, 'idx_circleId', enums.IndexType.key, <String>[
    'circleId',
  ]);
  await _ensureIndex(id, 'idx_senderMemberId', enums.IndexType.key, <String>[
    'senderMemberId',
  ]);
  await _ensureIndex(id, 'idx_recipientMemberId', enums.IndexType.key, <String>[
    'recipientMemberId',
  ]);
}

Future<void> _provisionKeptLumis() async {
  const String id = 'kept_lumis';
  await _ensureCollection(id, 'Kept Lumis', <String>[
    Permission.create(Role.users()),
  ]);
  await _ensureStringAttr(id, 'userId', size: 64, required: true);
  await _ensureStringAttr(id, 'lumiId', size: 64, required: true);
  await _ensureDatetimeAttr(id, 'keptAt', required: true);
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_userId', enums.IndexType.key, <String>['userId']);
}

Future<void> _provisionSettings() async {
  const String id = 'settings';
  await _ensureCollection(id, 'Settings', <String>[
    Permission.create(Role.users()),
  ]);
  await _ensureStringAttr(id, 'userId', size: 64, required: true);
  await _ensureBoolAttr(id, 'notificationsEnabled');
  await _ensureBoolAttr(id, 'hapticsEnabled');
  await _ensureBoolAttr(id, 'quietHoursEnabled');
  await _ensureIntAttr(id, 'quietHoursStartHour');
  await _ensureIntAttr(id, 'quietHoursStartMinute');
  await _ensureIntAttr(id, 'quietHoursEndHour');
  await _ensureIntAttr(id, 'quietHoursEndMinute');
  await _ensureStringAttr(id, 'mutedMembers', size: 64, array: true);
  await _waitForAttributes(id);
  await _ensureIndex(id, 'idx_userId', enums.IndexType.unique, <String>[
    'userId',
  ]);
}

// ---------------- Helpers ----------------

Future<void> _ensureDatabase() async {
  try {
    await databases.create(databaseId: _databaseId, name: _databaseName);
    stdout.writeln('+ database $_databaseId');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '= database $_databaseId');
  }
}

Future<void> _ensureCollection(
  String collectionId,
  String name,
  List<String> permissions,
) async {
  try {
    await databases.createCollection(
      databaseId: _databaseId,
      collectionId: collectionId,
      name: name,
      permissions: permissions,
      documentSecurity: true,
    );
    stdout.writeln('+ collection $collectionId');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '= collection $collectionId');
  }
}

Future<void> _ensureStringAttr(
  String collectionId,
  String key, {
  int size = 256,
  bool required = false,
  bool array = false,
}) async {
  try {
    await databases.createStringAttribute(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      size: size,
      xrequired: required,
      array: array,
    );
    stdout.writeln('  + $collectionId.$key (string)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId.$key');
  }
}

Future<void> _ensureIntAttr(
  String collectionId,
  String key, {
  bool required = false,
}) async {
  try {
    await databases.createIntegerAttribute(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      xrequired: required,
    );
    stdout.writeln('  + $collectionId.$key (int)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId.$key');
  }
}

Future<void> _ensureBoolAttr(
  String collectionId,
  String key, {
  bool required = false,
}) async {
  try {
    await databases.createBooleanAttribute(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      xrequired: required,
    );
    stdout.writeln('  + $collectionId.$key (bool)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId.$key');
  }
}

Future<void> _ensureFloatAttr(
  String collectionId,
  String key, {
  bool required = false,
}) async {
  try {
    await databases.createFloatAttribute(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      xrequired: required,
    );
    stdout.writeln('  + $collectionId.$key (float)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId.$key');
  }
}

Future<void> _ensureDatetimeAttr(
  String collectionId,
  String key, {
  bool required = false,
}) async {
  try {
    await databases.createDatetimeAttribute(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      xrequired: required,
    );
    stdout.writeln('  + $collectionId.$key (datetime)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId.$key');
  }
}

Future<void> _ensureIndex(
  String collectionId,
  String key,
  enums.IndexType type,
  List<String> attributes, {
  List<String>? orders,
}) async {
  try {
    await databases.createIndex(
      databaseId: _databaseId,
      collectionId: collectionId,
      key: key,
      type: type,
      attributes: attributes,
      orders: orders,
    );
    stdout.writeln('  + $collectionId/$key (index)');
  } on AppwriteException catch (e) {
    _onConflictOrRethrow(e, '  = $collectionId/$key');
  }
}

Future<void> _waitForAttributes(String collectionId) async {
  for (int attempt = 0; attempt < 30; attempt++) {
    final result = await databases.listAttributes(
      databaseId: _databaseId,
      collectionId: collectionId,
    );
    final bool allReady = result.attributes.every((dynamic attr) {
      final Map<String, dynamic> data = attr is Map<String, dynamic>
          ? attr
          : (attr as dynamic).toMap() as Map<String, dynamic>;
      return data['status'] == 'available';
    });
    if (allReady) {
      return;
    }
    await Future<void>.delayed(const Duration(seconds: 1));
  }
  stderr.writeln(
    'Warning: attributes for "$collectionId" did not become available in 30s.',
  );
}

void _onConflictOrRethrow(AppwriteException e, String existsLog) {
  if (e.code == 409) {
    stdout.writeln(existsLog);
    return;
  }
  throw e;
}
