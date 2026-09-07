import 'dart:convert';

import 'package:postgrest/postgrest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

const int _defaultColorValue = 0xFFFF7D6B;

class LumiRemoteDataSource {
  LumiRemoteDataSource({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<List<Lumi>> getRecentLumis({String? memberId}) async {
    final String? currentUserId = _currentUserIdOrNull();
    if (currentUserId == null) {
      return <Lumi>[];
    }

    final List<dynamic> incoming = await _client
        .from('lumis')
        .select()
        .eq('recipient_id', currentUserId)
        .order('created_at', ascending: false)
        .limit(100);
    final List<dynamic> outgoing = await _client
        .from('lumis')
        .select()
        .eq('sender_id', currentUserId)
        .order('created_at', ascending: false)
        .limit(100);

    final Map<String, Map<String, dynamic>> byId = <String, Map<String, dynamic>>{};
    for (final dynamic row in incoming) {
      final Map<String, dynamic> map = row as Map<String, dynamic>;
      byId[map['id'] as String] = map;
    }
    for (final dynamic row in outgoing) {
      final Map<String, dynamic> map = row as Map<String, dynamic>;
      byId[map['id'] as String] = map;
    }

    final List<Lumi> lumis =
        byId.values
            .map((Map<String, dynamic> row) => _lumiFromRow(row, currentUserId))
            .where((Lumi lumi) => memberId == null || lumi.memberId == memberId)
            .toList(growable: false)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return lumis;
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
    final FunctionResponse response = await _client.functions.invoke(
      'send_lumi',
      body: <String, dynamic>{
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
      },
    );

    if (response.status < 200 || response.status >= 300) {
      final String message = _errorMessage(response.data) ?? 'Unable to send Lumi.';
      throw PostgrestException(message: message, code: '${response.status}');
    }

    final Object? data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('send_lumi returned an invalid response.');
    }
    return _lumiFromRow(data, senderId);
  }

  Future<Lumi> markSeen(String lumiId) async {
    final String currentUserId = _currentUserId();
    final Map<String, dynamic> row = await _client
        .from('lumis')
        .update(<String, dynamic>{
          'seen_at': DateTime.now().toUtc().toIso8601String(),
          'delivery_status': LumiDeliveryStatus.seen.name,
        })
        .eq('id', lumiId)
        .select()
        .single();
    return _lumiFromRow(row, currentUserId);
  }

  Future<Lumi> reactToLumi({
    required String lumiId,
    required LumiReactionType reaction,
  }) async {
    final FunctionResponse response = await _client.functions.invoke(
      'react_lumi',
      body: <String, dynamic>{
        'lumiId': lumiId,
        'reaction': reaction.name,
      },
    );

    if (response.status < 200 || response.status >= 300) {
      final String message =
          _errorMessage(response.data) ?? 'Unable to send your reaction.';
      throw PostgrestException(message: message, code: '${response.status}');
    }

    final Object? data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('react_lumi returned an invalid response.');
    }
    final String currentUserId = _currentUserId();
    return _lumiFromRow(data, currentUserId);
  }

  String _currentUserId() {
    final User? user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Not authenticated.');
    }
    return user.id;
  }

  String? _currentUserIdOrNull() => _client.auth.currentUser?.id;

  Lumi _lumiFromRow(Map<String, dynamic> data, String currentUserId) {
    final String senderId = data['sender_id'] as String? ?? '';
    final String recipientId = data['recipient_id'] as String? ?? '';
    final bool isIncoming =
        recipientId == currentUserId && senderId != currentUserId;
    final String memberId = isIncoming
        ? data['recipient_member_id'] as String? ??
              data['circle_id'] as String? ??
              ''
        : data['sender_member_id'] as String? ??
              data['circle_id'] as String? ??
              '';
    final String? reaction = data['reaction_emoji'] as String?;

    return Lumi(
      id: data['id'] as String? ?? '',
      senderId: senderId,
      memberId: memberId,
      isIncoming: isIncoming,
      type: LumiType.values.byName(
        data['type'] as String? ?? LumiType.pure.name,
      ),
      colorValue: data['color_value'] as int? ?? _defaultColorValue,
      createdAt:
          DateTime.tryParse(data['created_at'] as String? ?? '') ??
          DateTime.now(),
      intensity: (data['intensity'] as num?)?.toDouble() ?? 0.7,
      deliveryStatus: _deliveryStatusFromRow(data),
      reaction: reaction == null || reaction.isEmpty
          ? null
          : LumiReactionType.values.byName(reaction),
      pulsePattern: _pulsePatternFromJson(data['pulse_pattern_json'] as String?),
      doodleStroke: _doodleStrokeFromJson(data['doodle_stroke_json'] as String?),
    );
  }

  LumiDeliveryStatus _deliveryStatusFromRow(Map<String, dynamic> data) {
    final String? status = data['delivery_status'] as String?;
    if (status != null && status.isNotEmpty) {
      return LumiDeliveryStatus.values.byName(status);
    }
    if ((data['seen_at'] as String?)?.isNotEmpty == true) {
      return LumiDeliveryStatus.seen;
    }
    if ((data['reaction_emoji'] as String?)?.isNotEmpty == true) {
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

  String? _errorMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final Object? error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }
    if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }
}
