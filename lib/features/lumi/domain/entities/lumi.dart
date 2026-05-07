import 'package:equatable/equatable.dart';

enum LumiType { pure, pulse, doodle, light }

extension LumiTypeX on LumiType {
  String get label => switch (this) {
    LumiType.pure => 'Pure Lumi',
    LumiType.pulse => 'Pulse Lumi',
    LumiType.doodle => 'Doodle Lumi',
    LumiType.light => 'Light Lumi',
  };
}

enum LumiDeliveryStatus { queued, sent, delivered, reacted, seen }

enum LumiReactionType { heart, smile, handOnHeart, sun, moon }

extension LumiReactionTypeX on LumiReactionType {
  String get emoji => switch (this) {
    LumiReactionType.heart => '♥',
    LumiReactionType.smile => '☺',
    LumiReactionType.handOnHeart => '🤍',
    LumiReactionType.sun => '☀',
    LumiReactionType.moon => '☾',
  };
}

class PulsePattern extends Equatable {
  const PulsePattern(this.beats);

  final List<int> beats;

  Map<String, dynamic> toJson() => <String, dynamic>{'beats': beats};

  factory PulsePattern.fromJson(Map<String, dynamic> json) => PulsePattern(
    (json['beats'] as List<dynamic>? ?? const <dynamic>[])
        .map((value) => value as int)
        .toList(growable: false),
  );

  @override
  List<Object?> get props => <Object?>[beats];
}

class DoodlePoint extends Equatable {
  const DoodlePoint({required this.dx, required this.dy});

  final double dx;
  final double dy;

  Map<String, dynamic> toJson() => <String, dynamic>{'dx': dx, 'dy': dy};

  factory DoodlePoint.fromJson(Map<String, dynamic> json) => DoodlePoint(
    dx: (json['dx'] as num?)?.toDouble() ?? 0,
    dy: (json['dy'] as num?)?.toDouble() ?? 0,
  );

  @override
  List<Object?> get props => <Object?>[dx, dy];
}

class DoodleStroke extends Equatable {
  const DoodleStroke(this.points);

  final List<DoodlePoint> points;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'points': points.map((point) => point.toJson()).toList(growable: false),
  };

  factory DoodleStroke.fromJson(Map<String, dynamic> json) => DoodleStroke(
    (json['points'] as List<dynamic>? ?? const <dynamic>[])
        .map((value) => DoodlePoint.fromJson(value as Map<String, dynamic>))
        .toList(growable: false),
  );

  @override
  List<Object?> get props => <Object?>[points];
}

class Lumi extends Equatable {
  const Lumi({
    required this.id,
    required this.senderId,
    required this.memberId,
    required this.isIncoming,
    required this.type,
    required this.colorValue,
    required this.createdAt,
    this.intensity = 0.7,
    this.deliveryStatus = LumiDeliveryStatus.sent,
    this.reaction,
    this.pulsePattern,
    this.doodleStroke,
    this.isKept = false,
  });

  final String id;
  final String senderId;
  final String memberId;
  final bool isIncoming;
  final LumiType type;
  final int colorValue;
  final DateTime createdAt;
  final double intensity;
  final LumiDeliveryStatus deliveryStatus;
  final LumiReactionType? reaction;
  final PulsePattern? pulsePattern;
  final DoodleStroke? doodleStroke;
  final bool isKept;

  Lumi copyWith({
    LumiDeliveryStatus? deliveryStatus,
    LumiReactionType? reaction,
    bool? isKept,
  }) {
    return Lumi(
      id: id,
      senderId: senderId,
      memberId: memberId,
      isIncoming: isIncoming,
      type: type,
      colorValue: colorValue,
      createdAt: createdAt,
      intensity: intensity,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      reaction: reaction ?? this.reaction,
      pulsePattern: pulsePattern,
      doodleStroke: doodleStroke,
      isKept: isKept ?? this.isKept,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'senderId': senderId,
    'memberId': memberId,
    'isIncoming': isIncoming,
    'type': type.name,
    'colorValue': colorValue,
    'createdAt': createdAt.toIso8601String(),
    'intensity': intensity,
    'deliveryStatus': deliveryStatus.name,
    'reaction': reaction?.name,
    'pulsePattern': pulsePattern?.toJson(),
    'doodleStroke': doodleStroke?.toJson(),
    'isKept': isKept,
  };

  factory Lumi.fromJson(Map<String, dynamic> json) => Lumi(
    id: json['id'] as String? ?? '',
    senderId: json['senderId'] as String? ?? '',
    memberId: json['memberId'] as String? ?? '',
    isIncoming: json['isIncoming'] as bool? ?? false,
    type: LumiType.values.byName(json['type'] as String? ?? LumiType.pure.name),
    colorValue: json['colorValue'] as int? ?? 0xFFFF7F7F,
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    intensity: (json['intensity'] as num?)?.toDouble() ?? 0.7,
    deliveryStatus: LumiDeliveryStatus.values.byName(
      json['deliveryStatus'] as String? ?? LumiDeliveryStatus.sent.name,
    ),
    reaction: (json['reaction'] as String?) == null
        ? null
        : LumiReactionType.values.byName(json['reaction'] as String),
    pulsePattern: json['pulsePattern'] == null
        ? null
        : PulsePattern.fromJson(json['pulsePattern'] as Map<String, dynamic>),
    doodleStroke: json['doodleStroke'] == null
        ? null
        : DoodleStroke.fromJson(json['doodleStroke'] as Map<String, dynamic>),
    isKept: json['isKept'] as bool? ?? false,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    senderId,
    memberId,
    isIncoming,
    type,
    colorValue,
    createdAt,
    intensity,
    deliveryStatus,
    reaction,
    pulsePattern,
    doodleStroke,
    isKept,
  ];
}
