import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import 'package:appwrite/models.dart' as models;

import 'package:lumi/core/network/appwrite_client.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

const String _databaseId = 'lumi';
const String _lumisTable = 'lumis';
const String _sendLumiFunctionId = 'send_lumi';

const int _defaultColorValue = 0xFFFF7D6B;

class LumiRemoteDataSource {
  LumiRemoteDataSource({
    TablesDB? tablesDb,
    Account? account,
    Functions? functions,
  }) : _tablesDb = tablesDb ?? TablesDB(client),
       _account = account ?? Account(client),
       _functions = functions ?? Functions(client);

  final TablesDB _tablesDb;
  final Account _account;
  final Functions _functions;

  Future<List<Lumi>> getRecentLumis({String? memberId}) async {
    final String? currentUserId = await _currentUserIdOrNull();
    if (currentUserId == null) {
      return <Lumi>[];
    }

    final List<models.Row> rows = await _listUserLumiRows(currentUserId);

    final List<Lumi> lumis =
        rows
            .map((models.Row row) => _lumiFromRow(row, currentUserId))
            .where((Lumi lumi) => memberId == null || lumi.memberId == memberId)
            .toList(growable: false)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return lumis;
  }

  Future<List<models.Row>> _listUserLumiRows(String userId) async {
    final models.RowList incoming = await _tablesDb.listRows(
      databaseId: _databaseId,
      tableId: _lumisTable,
      queries: <String>[Query.equal('recipientId', userId), Query.limit(100)],
    );
    final models.RowList outgoing = await _tablesDb.listRows(
      databaseId: _databaseId,
      tableId: _lumisTable,
      queries: <String>[Query.equal('senderId', userId), Query.limit(100)],
    );

    final Map<String, models.Row> byId = <String, models.Row>{};
    for (final models.Row row in incoming.rows) {
      byId[row.$id] = row;
    }
    for (final models.Row row in outgoing.rows) {
      byId[row.$id] = row;
    }
    return byId.values.toList(growable: false);
  }

  Future<Lumi> sendLumi({
    required String senderId,
    required String senderMemberId,
    required LumiType type,
    required int colorValue,
    required double intensity,
    PulsePattern? pulsePattern,
    DoodleStroke? doodleStroke,
    required bool queued,
  }) async {
    final models.Execution execution = await _functions.createExecution(
      functionId: _sendLumiFunctionId,
      xasync: false,
      method: enums.ExecutionMethod.pOST,
      body: jsonEncode(<String, dynamic>{
        'senderId': senderId,
        'senderMemberId': senderMemberId,
        'type': type.name,
        'colorValue': colorValue,
        'intensity': intensity,
        'deliveryStatus': queued
            ? LumiDeliveryStatus.queued.name
            : LumiDeliveryStatus.delivered.name,
        'pulsePatternJson': pulsePattern == null
            ? null
            : jsonEncode(pulsePattern.toJson()),
        'doodleStrokeJson': doodleStroke == null
            ? null
            : jsonEncode(doodleStroke.toJson()),
      }),
    );

    if (execution.responseStatusCode < 200 ||
        execution.responseStatusCode >= 300) {
      throw AppwriteException(
        execution.responseBody.isEmpty
            ? 'Unable to send Lumi.'
            : execution.responseBody,
        execution.responseStatusCode,
      );
    }

    final Object? decoded = jsonDecode(execution.responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('send_lumi returned an invalid response.');
    }
    final models.Row row = models.Row.fromMap(decoded);
    return _lumiFromRow(row, senderId);
  }

  Future<Lumi> markSeen(String lumiId) async {
    final String currentUserId = await _currentUserId();
    final models.Row row = await _tablesDb.updateRow(
      databaseId: _databaseId,
      tableId: _lumisTable,
      rowId: lumiId,
      data: <String, dynamic>{
        'seenAt': DateTime.now().toUtc().toIso8601String(),
        'deliveryStatus': LumiDeliveryStatus.seen.name,
      },
    );
    return _lumiFromRow(row, currentUserId);
  }

  Future<Lumi> reactToLumi({
    required String lumiId,
    required LumiReactionType reaction,
  }) async {
    final String currentUserId = await _currentUserId();
    final models.Row row = await _tablesDb.updateRow(
      databaseId: _databaseId,
      tableId: _lumisTable,
      rowId: lumiId,
      data: <String, dynamic>{
        'reactionEmoji': reaction.name,
        'deliveryStatus': LumiDeliveryStatus.reacted.name,
      },
    );
    return _lumiFromRow(row, currentUserId);
  }

  Future<String> _currentUserId() async {
    final models.User user = await _account.get();
    return user.$id;
  }

  Future<String?> _currentUserIdOrNull() async {
    try {
      return await _currentUserId();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return null;
      }
      rethrow;
    }
  }

  Lumi _lumiFromRow(models.Row row, String currentUserId) {
    final Map<String, dynamic> data = row.data;
    final String senderId = data['senderId'] as String? ?? '';
    final String recipientId = data['recipientId'] as String? ?? '';
    final bool isIncoming =
        recipientId == currentUserId && senderId != currentUserId;
    final String memberId = isIncoming
        ? data['recipientMemberId'] as String? ??
              data['circleId'] as String? ??
              ''
        : data['senderMemberId'] as String? ??
              data['circleId'] as String? ??
              '';
    final String? reaction = data['reactionEmoji'] as String?;

    return Lumi(
      id: row.$id,
      senderId: senderId,
      memberId: memberId,
      isIncoming: isIncoming,
      type: LumiType.values.byName(
        data['type'] as String? ?? LumiType.pure.name,
      ),
      colorValue: data['colorValue'] as int? ?? _defaultColorValue,
      createdAt:
          DateTime.tryParse(data['createdAt'] as String? ?? '') ??
          DateTime.tryParse(row.$createdAt) ??
          DateTime.now(),
      intensity: (data['intensity'] as num?)?.toDouble() ?? 0.7,
      deliveryStatus: _deliveryStatusFromRow(data),
      reaction: reaction == null || reaction.isEmpty
          ? null
          : LumiReactionType.values.byName(reaction),
      pulsePattern: _pulsePatternFromJson(data['pulsePatternJson'] as String?),
      doodleStroke: _doodleStrokeFromJson(data['doodleStrokeJson'] as String?),
    );
  }

  LumiDeliveryStatus _deliveryStatusFromRow(Map<String, dynamic> data) {
    final String? status = data['deliveryStatus'] as String?;
    if (status != null && status.isNotEmpty) {
      return LumiDeliveryStatus.values.byName(status);
    }
    if ((data['seenAt'] as String?)?.isNotEmpty == true) {
      return LumiDeliveryStatus.seen;
    }
    if ((data['reactionEmoji'] as String?)?.isNotEmpty == true) {
      return LumiDeliveryStatus.reacted;
    }
    return LumiDeliveryStatus.delivered;
  }

  PulsePattern? _pulsePatternFromJson(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return PulsePattern.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  DoodleStroke? _doodleStrokeFromJson(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DoodleStroke.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
