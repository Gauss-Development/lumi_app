import 'package:equatable/equatable.dart';

class LumiPushPayload extends Equatable {
  const LumiPushPayload({
    this.lumiId,
    this.senderMemberId,
    this.recipientMemberId,
    this.type,
    this.senderName,
    this.senderColorValue,
    this.reaction,
  });

  final String? lumiId;
  final String? senderMemberId;
  final String? recipientMemberId;
  final String? type;
  final String? senderName;
  final int? senderColorValue;
  final String? reaction;

  bool get isReaction => type == 'reaction';

  /// Circle member id to focus on the home screen after opening a push.
  String? get focusMemberId =>
      isReaction ? senderMemberId : recipientCircleMemberId;

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
      reaction: _stringValue(data['reaction']),
    );
  }

  static String privacySafeBody({String? senderName}) {
    final String trimmed = senderName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'You received a Lumi.';
    }
    return 'A Lumi from $trimmed';
  }

  String get body => isReaction
      ? reactionBody(senderName: senderName, reaction: reaction)
      : privacySafeBody(senderName: senderName);

  static String reactionBody({String? senderName, String? reaction}) {
    final String trimmed = senderName?.trim() ?? '';
    final String name = trimmed.isEmpty ? 'Someone' : trimmed;
    return '$name felt your Lumi ${_reactionEmoji(reaction)}';
  }

  static String _reactionEmoji(String? reaction) {
    if (reaction == null || reaction.isEmpty) {
      return '♥';
    }
    return _reactionEmojis[reaction] ?? '♥';
  }

  static const Map<String, String> _reactionEmojis = <String, String>{
    'heart': '♥',
    'smile': '☺',
    'handOnHeart': '🤍',
    'sun': '☀',
    'moon': '☾',
  };

  /// Member row id on the recipient's circle (the orb that should glow).
  String? get recipientCircleMemberId => recipientMemberId;

  Map<String, String> toStorageMap() {
    return <String, String>{
      if (lumiId != null) 'lumiId': lumiId!,
      if (senderMemberId != null) 'senderMemberId': senderMemberId!,
      if (recipientMemberId != null) 'recipientMemberId': recipientMemberId!,
      if (type != null) 'type': type!,
      if (senderName != null) 'senderName': senderName!,
      if (senderColorValue != null)
        'senderColorValue': senderColorValue!.toString(),
      if (reaction != null) 'reaction': reaction!,
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
    reaction,
  ];
}
