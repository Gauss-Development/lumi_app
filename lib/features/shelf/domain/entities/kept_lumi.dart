import 'package:equatable/equatable.dart';

class KeptLumi extends Equatable {
  const KeptLumi({
    required this.id,
    required this.lumiId,
    required this.senderId,
    required this.senderName,
    required this.savedAt,
    required this.previewLabel,
    required this.colorValue,
  });

  final String id;
  final String lumiId;
  final String senderId;
  final String senderName;
  final DateTime savedAt;
  final String previewLabel;
  final int colorValue;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'lumiId': lumiId,
    'senderId': senderId,
    'senderName': senderName,
    'savedAt': savedAt.toIso8601String(),
    'previewLabel': previewLabel,
    'colorValue': colorValue,
  };

  factory KeptLumi.fromJson(Map<String, dynamic> json) => KeptLumi(
    id: json['id'] as String,
    lumiId: json['lumiId'] as String,
    senderId: json['senderId'] as String,
    senderName: json['senderName'] as String,
    savedAt: DateTime.parse(json['savedAt'] as String),
    previewLabel: json['previewLabel'] as String,
    colorValue: json['colorValue'] as int? ?? 0xFFFF7D6B,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    lumiId,
    senderId,
    senderName,
    savedAt,
    previewLabel,
    colorValue,
  ];
}
