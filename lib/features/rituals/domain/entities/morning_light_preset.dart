import 'package:equatable/equatable.dart';

class MorningLightPreset extends Equatable {
  const MorningLightPreset({
    required this.id,
    required this.label,
    required this.memberIds,
  });

  final String id;
  final String label;
  final List<String> memberIds;

  @override
  List<Object?> get props => [id, label, memberIds];
}
