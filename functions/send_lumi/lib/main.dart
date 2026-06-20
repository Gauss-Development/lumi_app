import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart' as models;

const String _databaseId = 'lumi';
const String _membersCollection = 'circle_members';
const String _lumisCollection = 'lumis';
const int _defaultColorValue = 0xFFFF7D6B;
const int _paceLimitPerDay = 5;
const Set<String> _allowedTypes = <String>{
  'pure',
  'light',
  'pulse',
  'doodle',
};

Future<dynamic> main(dynamic context) async {
  try {
    final Map<String, dynamic> headers = _headers(context.req.headers);
    final String senderUserId = _requiredHeader(headers, 'x-appwrite-user-id');
    final String apiKey = _requiredHeader(headers, 'x-appwrite-key');
    final Map<String, dynamic> body = _requestBody(context.req);

    final String claimedSenderId = _requiredString(body, 'senderId');
    if (claimedSenderId != senderUserId) {
      return _json(
          context,
          <String, dynamic>{
            'error': 'senderId does not match the session user.',
          },
          403);
    }

    final String senderMemberId = _requiredString(body, 'senderMemberId');
    final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
        Platform.environment['APPWRITE_FUNCTION_ENDPOINT'] ??
        'https://sfo.cloud.appwrite.io/v1';
    final String projectId =
        Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ??
            Platform.environment['APPWRITE_PROJECT_ID'] ??
            '';
    if (projectId.isEmpty) {
      return _json(
          context,
          <String, dynamic>{
            'error': 'APPWRITE_FUNCTION_PROJECT_ID is missing.',
          },
          500);
    }

    final Client client =
        Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
    final Databases databases = Databases(client);

    final models.Document member = await databases.getDocument(
      databaseId: _databaseId,
      collectionId: _membersCollection,
      documentId: senderMemberId,
    );
    final Map<String, dynamic> memberData = _documentData(member);

    if (memberData['ownerUserId'] != senderUserId) {
      return _json(
          context,
          <String, dynamic>{
            'error': 'This circle member is not owned by you.',
          },
          403);
    }
    if (memberData['status'] != 'active' ||
        memberData['mutualConnection'] != true) {
      return _json(
          context,
          <String, dynamic>{
            'error': 'This circle member is not connected.',
          },
          409);
    }

    final String recipientUserId = memberData['memberUserId'] as String? ?? '';
    final String recipientMemberId =
        memberData['reciprocalMemberId'] as String? ?? '';
    if (recipientUserId.isEmpty || recipientMemberId.isEmpty) {
      return _json(
          context,
          <String, dynamic>{
            'error': 'Circle member is not linked.',
          },
          409);
    }

    if (_isAtPaceLimit(memberData)) {
      return _json(
          context,
          <String, dynamic>{
            'error':
                'Gentle limit reached for this person today. Try again tomorrow.',
          },
          429);
    }

    final String type = _requiredString(body, 'type');
    if (!_allowedTypes.contains(type)) {
      return _json(
          context,
          <String, dynamic>{'error': 'Unsupported Lumi type.'},
          400);
    }

    final String? pulsePatternJson = body['pulsePatternJson'] as String?;
    final String? doodleStrokeJson = body['doodleStrokeJson'] as String?;
    _validatePayload(
      type: type,
      pulsePatternJson: pulsePatternJson,
      doodleStrokeJson: doodleStrokeJson,
    );

    final double intensity =
        ((body['intensity'] as num?)?.toDouble() ?? 0.7).clamp(0.2, 1.0);

    final Map<String, dynamic> data = <String, dynamic>{
      'senderId': senderUserId,
      'recipientId': recipientUserId,
      'senderMemberId': senderMemberId,
      'recipientMemberId': recipientMemberId,
      'circleId': senderMemberId,
      'type': type,
      'colorValue': body['colorValue'] as int? ?? _defaultColorValue,
      'intensity': intensity,
      'deliveryStatus': body['deliveryStatus'] as String? ?? 'delivered',
      'pulsePatternJson': pulsePatternJson,
      'doodleStrokeJson': doodleStrokeJson,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };

    final models.Document lumi = await databases.createDocument(
      databaseId: _databaseId,
      collectionId: _lumisCollection,
      documentId: ID.unique(),
      data: data,
      permissions: <String>[
        Permission.read(Role.user(senderUserId)),
        Permission.read(Role.user(recipientUserId)),
        Permission.update(Role.user(recipientUserId)),
        Permission.delete(Role.user(senderUserId)),
      ],
    );

    await databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _membersCollection,
      documentId: senderMemberId,
      data: <String, dynamic>{
        'paceCount': _nextPaceCount(memberData),
        'lastInteractionAt': DateTime.now().toUtc().toIso8601String(),
      },
    );

    await _sendPushNotification(
      client: client,
      lumiId: lumi.$id,
      recipientUserId: recipientUserId,
      senderMemberId: senderMemberId,
      recipientMemberId: recipientMemberId,
      type: data['type'] as String,
    );

    return _json(context, _rowMap(lumi, _lumisCollection), 201);
  } on AppwriteException catch (e) {
    final int statusCode = e.code == null || e.code == 0 ? 500 : e.code!;
    return _json(
        context,
        <String, dynamic>{
          'error': e.message ?? 'Appwrite error',
          'code': e.code,
        },
        statusCode);
  } on FormatException catch (e) {
    return _json(context, <String, dynamic>{'error': e.message}, 400);
  } on StateError catch (e) {
    return _json(context, <String, dynamic>{'error': e.message}, 400);
  } catch (e) {
    return _json(context, <String, dynamic>{'error': e.toString()}, 500);
  }
}

Future<void> _sendPushNotification({
  required Client client,
  required String lumiId,
  required String recipientUserId,
  required String senderMemberId,
  required String recipientMemberId,
  required String type,
}) async {
  try {
    await Messaging(client).createPush(
      messageId: ID.unique(),
      title: 'Lumi',
      body: 'You received a Lumi.',
      users: <String>[recipientUserId],
      data: <String, dynamic>{
        'lumiId': lumiId,
        'senderMemberId': senderMemberId,
        'recipientMemberId': recipientMemberId,
        'type': type,
      },
      draft: false,
    );
  } on AppwriteException {
    // Push is an accelerator, not the source of truth. The row above is enough
    // for polling/retry delivery, so missing providers or targets must not
    // break sending.
  }
}

dynamic _json(dynamic context, Map<String, dynamic> body, int statusCode) {
  try {
    return context.res.json(body, statusCode);
  } on NoSuchMethodError {
    try {
      context.res.setStatusCode(statusCode);
      context.res.setHeader('content-type', 'application/json');
      return context.res.send(jsonEncode(body));
    } on NoSuchMethodError {
      return context.res.json(body);
    }
  }
}

Map<String, dynamic> _headers(Object? rawHeaders) {
  if (rawHeaders is! Map) {
    return <String, dynamic>{};
  }
  return rawHeaders.map(
    (Object? key, Object? value) =>
        MapEntry<String, dynamic>(key.toString().toLowerCase(), value),
  );
}

String _requiredHeader(Map<String, dynamic> headers, String key) {
  final Object? value = headers[key.toLowerCase()];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw StateError('$key header is missing.');
}

Map<String, dynamic> _requestBody(dynamic req) {
  final Object? bodyJson = req.bodyJson;
  if (bodyJson is Map) {
    return bodyJson.cast<String, dynamic>();
  }
  final Object? body = _bodyText(req);
  if (body is String && body.isNotEmpty) {
    final Object? decoded = jsonDecode(body);
    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }
  }
  throw const FormatException('Request body must be a JSON object.');
}

Object? _bodyText(dynamic req) {
  try {
    return req.bodyText;
  } on NoSuchMethodError {
    return req.body;
  }
}

String _requiredString(Map<String, dynamic> body, String key) {
  final Object? value = body[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('$key is required.');
}

Map<String, dynamic> _documentData(models.Document document) {
  return Map<String, dynamic>.from(document.data)
    ..removeWhere((String key, Object? value) => key.startsWith(r'$'));
}

bool _isAtPaceLimit(Map<String, dynamic> memberData) {
  final int paceCount = memberData['paceCount'] as int? ?? 0;
  final String? lastInteractionRaw =
      memberData['lastInteractionAt'] as String?;
  if (lastInteractionRaw == null || lastInteractionRaw.isEmpty) {
    return false;
  }
  final DateTime lastInteraction = DateTime.parse(lastInteractionRaw).toUtc();
  final Duration since = DateTime.now().toUtc().difference(lastInteraction);
  if (since.inHours >= 24) {
    return false;
  }
  return paceCount >= _paceLimitPerDay;
}

int _nextPaceCount(Map<String, dynamic> memberData) {
  final int paceCount = memberData['paceCount'] as int? ?? 0;
  final String? lastInteractionRaw =
      memberData['lastInteractionAt'] as String?;
  if (lastInteractionRaw == null || lastInteractionRaw.isEmpty) {
    return 1;
  }
  final DateTime lastInteraction = DateTime.parse(lastInteractionRaw).toUtc();
  final Duration since = DateTime.now().toUtc().difference(lastInteraction);
  if (since.inHours >= 24) {
    return 1;
  }
  return paceCount + 1;
}

void _validatePayload({
  required String type,
  required String? pulsePatternJson,
  required String? doodleStrokeJson,
}) {
  switch (type) {
    case 'pulse':
      if (pulsePatternJson == null || pulsePatternJson.isEmpty) {
        throw const FormatException('pulsePatternJson is required for pulse.');
      }
      final Object? decoded = jsonDecode(pulsePatternJson);
      if (decoded is! Map) {
        throw const FormatException('pulsePatternJson must be an object.');
      }
      final List<dynamic> beats =
          decoded['beats'] as List<dynamic>? ?? <dynamic>[];
      if (beats.length < 2) {
        throw const FormatException('Pulse needs at least two beat intervals.');
      }
    case 'doodle':
      if (doodleStrokeJson == null || doodleStrokeJson.isEmpty) {
        throw const FormatException('doodleStrokeJson is required for doodle.');
      }
      final Object? decoded = jsonDecode(doodleStrokeJson);
      if (decoded is! Map) {
        throw const FormatException('doodleStrokeJson must be an object.');
      }
      final List<dynamic> points =
          decoded['points'] as List<dynamic>? ?? <dynamic>[];
      if (points.length < 2) {
        throw const FormatException('Doodle needs at least two points.');
      }
    case 'light':
    case 'pure':
      return;
  }
}

Map<String, dynamic> _rowMap(models.Document document, String tableId) {
  return <String, dynamic>{
    r'$id': document.$id,
    r'$sequence': '0',
    r'$tableId': tableId,
    r'$databaseId': document.$databaseId,
    r'$createdAt': document.$createdAt,
    r'$updatedAt': document.$updatedAt,
    r'$permissions': document.$permissions,
    'data': _documentData(document),
  };
}
