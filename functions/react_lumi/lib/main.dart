import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart' as models;

const String _databaseId = 'lumi';
const String _membersCollection = 'circle_members';
const String _lumisCollection = 'lumis';

const Set<String> _allowedReactions = <String>{
  'heart',
  'smile',
  'handOnHeart',
  'sun',
  'moon',
};

const Map<String, String> _reactionEmoji = <String, String>{
  'heart': '♥',
  'smile': '☺',
  'handOnHeart': '🤍',
  'sun': '☀',
  'moon': '☾',
};

Future<dynamic> main(dynamic context) async {
  try {
    final Map<String, dynamic> headers = _headers(context.req.headers);
    final String recipientUserId = _requiredHeader(headers, 'x-appwrite-user-id');
    final String apiKey = _requiredHeader(headers, 'x-appwrite-key');
    final Map<String, dynamic> body = _requestBody(context.req);

    final String lumiId = _requiredString(body, 'lumiId');
    final String reaction = _requiredString(body, 'reaction');
    if (!_allowedReactions.contains(reaction)) {
      return _json(
        context,
        <String, dynamic>{'error': 'Unsupported reaction.'},
        400,
      );
    }

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
        500,
      );
    }

    final Client client =
        Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
    final Databases databases = Databases(client);

    final models.Document lumi = await databases.getDocument(
      databaseId: _databaseId,
      collectionId: _lumisCollection,
      documentId: lumiId,
    );
    final Map<String, dynamic> lumiData = _documentData(lumi);

    final String storedRecipientId = lumiData['recipientId'] as String? ?? '';
    if (storedRecipientId != recipientUserId) {
      return _json(
        context,
        <String, dynamic>{
          'error': 'Only the recipient can react to this Lumi.',
        },
        403,
      );
    }

    final String senderUserId = lumiData['senderId'] as String? ?? '';
    final String senderMemberId = lumiData['senderMemberId'] as String? ?? '';
    if (senderUserId.isEmpty) {
      return _json(
        context,
        <String, dynamic>{'error': 'Lumi sender is missing.'},
        409,
      );
    }

    final models.Document updated = await databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _lumisCollection,
      documentId: lumiId,
      data: <String, dynamic>{
        'reactionEmoji': reaction,
        'deliveryStatus': 'reacted',
        'seenAt': DateTime.now().toUtc().toIso8601String(),
      },
    );

    final String reactorName = await _reactorDisplayName(
      databases: databases,
      senderMemberId: senderMemberId,
    );

    await _notifySender(
      client: client,
      senderUserId: senderUserId,
      lumiId: lumiId,
      reactorName: reactorName,
      reaction: reaction,
      senderMemberId: senderMemberId,
      recipientMemberId: lumiData['recipientMemberId'] as String? ?? '',
    );

    return _json(context, _rowMap(updated, _lumisCollection), 200);
  } on AppwriteException catch (e) {
    final int statusCode = e.code == null || e.code == 0 ? 500 : e.code!;
    return _json(
      context,
      <String, dynamic>{
        'error': e.message ?? 'Appwrite error',
        'code': e.code,
      },
      statusCode,
    );
  } on FormatException catch (e) {
    return _json(context, <String, dynamic>{'error': e.message}, 400);
  } on StateError catch (e) {
    return _json(context, <String, dynamic>{'error': e.message}, 400);
  } catch (e) {
    return _json(context, <String, dynamic>{'error': e.toString()}, 500);
  }
}

Future<String> _reactorDisplayName({
  required Databases databases,
  required String senderMemberId,
}) async {
  if (senderMemberId.isEmpty) {
    return 'Someone';
  }
  try {
    final models.Document member = await databases.getDocument(
      databaseId: _databaseId,
      collectionId: _membersCollection,
      documentId: senderMemberId,
    );
    final String? displayName = _documentData(member)['displayName'] as String?;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
  } on AppwriteException {
    // Fall back to a warm generic label.
  }
  return 'Someone';
}

Future<void> _notifySender({
  required Client client,
  required String senderUserId,
  required String lumiId,
  required String reactorName,
  required String reaction,
  required String senderMemberId,
  required String recipientMemberId,
}) async {
  final String emoji = _reactionEmoji[reaction] ?? '♥';
  try {
    await Messaging(client).createPush(
      messageId: ID.unique(),
      title: 'Lumi',
      body: '$reactorName felt your Lumi $emoji',
      users: <String>[senderUserId],
      data: <String, dynamic>{
        'type': 'reaction',
        'lumiId': lumiId,
        'reaction': reaction,
        'senderMemberId': senderMemberId,
        'recipientMemberId': recipientMemberId,
        'senderName': reactorName,
      },
      draft: false,
    );
  } on AppwriteException {
    // Reaction row is source of truth; push is optional.
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
