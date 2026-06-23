import 'package:equatable/equatable.dart';

class LumiPushPayload extends Equatable {
  const LumiPushPayload({
    this.lumiId,
    this.senderMemberId,
    this.recipientMemberId,
    this.type,
    this.senderName,
    this.senderColorValue,
  });

  final String? lumiId;
  final String? senderMemberId;
  final String? recipientMemberId;
  final String? type;
  final String? senderName;
  final int? senderColorValue;

  static LumiPushPayload? fromData(Map<String, dynamic> raw) {
    if (raw.isEmpty) {
      return null;
    }

    final Map<String, dynamic> data = raw.map(
      (String key, dynamic value) => MapEntry<String, dynamic>(key, value),
    );

    final String? lumiId = _stringValue(data['lumiId']);
    final String? senderMemberId = _stringValue(data['senderMemberId']);
    if (lumiId == null && senderMemberId == null) {
      return null;
    }

    return LumiPushPayload(
      lumiId: lumiId,
      senderMemberId: senderMemberId,
      recipientMemberId: _stringValue(data['recipientMemberId']),
      type: _stringValue(data['type']),
      senderName: _stringValue(data['senderName']),
      senderColorValue: _parseColorValue(data['senderColorValue']),
    );
  }

  static String privacySafeBody({String? senderName}) {
    final String trimmed = senderName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'You received a Lumi.';
    }
    return 'A Lumi from $trimmed';
  }

  String get body => privacySafeBody(senderName: senderName);

  Map<String, String> toStorageMap() {
    return <String, String>{
      'lumiId': ?lumiId,
      'senderMemberId': ?senderMemberId,
      'recipientMemberId': ?recipientMemberId,
      'type': ?type,
      'senderName': ?senderName,
      if (senderColorValue != null)
        'senderColorValue': senderColorValue!.toString(),
    };
  }

  static LumiPushPayload? fromStorageMap(Map<String, dynamic>? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return fromData(raw);
  }

  static String? _stringValue(Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  static int? _parseColorValue(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  List<Object?> get props => <Object?>[
    lumiId,
    senderMemberId,
    recipientMemberId,
    type,
    senderName,
    senderColorValue,
  ];
}
