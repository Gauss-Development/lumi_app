import 'package:equatable/equatable.dart';

enum RitualKind { morning, evening, checkIn }

class RitualPreferences extends Equatable {
  const RitualPreferences({
    this.morningEnabled = true,
    this.eveningEnabled = true,
    this.gentleRemindersEnabled = true,
    this.morningHour = 9,
    this.eveningHour = 21,
    this.reminderCadenceDays = 3,
    this.lastMorningSentAt,
    this.lastEveningSentAt,
    this.lastCheckInSentAt,
    this.dismissedUntil,
  });

  final bool morningEnabled;
  final bool eveningEnabled;
  final bool gentleRemindersEnabled;
  final int morningHour;
  final int eveningHour;
  final int reminderCadenceDays;
  final DateTime? lastMorningSentAt;
  final DateTime? lastEveningSentAt;
  final DateTime? lastCheckInSentAt;
  final DateTime? dismissedUntil;

  RitualPreferences copyWith({
    bool? morningEnabled,
    bool? eveningEnabled,
    bool? gentleRemindersEnabled,
    int? morningHour,
    int? eveningHour,
    int? reminderCadenceDays,
    DateTime? lastMorningSentAt,
    DateTime? lastEveningSentAt,
    DateTime? lastCheckInSentAt,
    DateTime? dismissedUntil,
  }) {
    return RitualPreferences(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      gentleRemindersEnabled:
          gentleRemindersEnabled ?? this.gentleRemindersEnabled,
      morningHour: morningHour ?? this.morningHour,
      eveningHour: eveningHour ?? this.eveningHour,
      reminderCadenceDays: reminderCadenceDays ?? this.reminderCadenceDays,
      lastMorningSentAt: lastMorningSentAt ?? this.lastMorningSentAt,
      lastEveningSentAt: lastEveningSentAt ?? this.lastEveningSentAt,
      lastCheckInSentAt: lastCheckInSentAt ?? this.lastCheckInSentAt,
      dismissedUntil: dismissedUntil ?? this.dismissedUntil,
    );
  }

  DateTime? lastSentAtFor(RitualKind kind) {
    return switch (kind) {
      RitualKind.morning => lastMorningSentAt,
      RitualKind.evening => lastEveningSentAt,
      RitualKind.checkIn => lastCheckInSentAt,
    };
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'morningEnabled': morningEnabled,
    'eveningEnabled': eveningEnabled,
    'gentleRemindersEnabled': gentleRemindersEnabled,
    'morningHour': morningHour,
    'eveningHour': eveningHour,
    'reminderCadenceDays': reminderCadenceDays,
    'lastMorningSentAt': lastMorningSentAt?.toIso8601String(),
    'lastEveningSentAt': lastEveningSentAt?.toIso8601String(),
    'lastCheckInSentAt': lastCheckInSentAt?.toIso8601String(),
    'dismissedUntil': dismissedUntil?.toIso8601String(),
  };

  factory RitualPreferences.fromJson(Map<String, dynamic> json) {
    return RitualPreferences(
      morningEnabled: json['morningEnabled'] as bool? ?? true,
      eveningEnabled: json['eveningEnabled'] as bool? ?? true,
      gentleRemindersEnabled: json['gentleRemindersEnabled'] as bool? ?? true,
      morningHour: json['morningHour'] as int? ?? 9,
      eveningHour: json['eveningHour'] as int? ?? 21,
      reminderCadenceDays: json['reminderCadenceDays'] as int? ?? 3,
      lastMorningSentAt: _date(json['lastMorningSentAt']),
      lastEveningSentAt: _date(json['lastEveningSentAt']),
      lastCheckInSentAt: _date(json['lastCheckInSentAt']),
      dismissedUntil: _date(json['dismissedUntil']),
    );
  }

  static DateTime? _date(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  @override
  List<Object?> get props => <Object?>[
    morningEnabled,
    eveningEnabled,
    gentleRemindersEnabled,
    morningHour,
    eveningHour,
    reminderCadenceDays,
    lastMorningSentAt,
    lastEveningSentAt,
    lastCheckInSentAt,
    dismissedUntil,
  ];
}

class RitualSuggestion extends Equatable {
  const RitualSuggestion({
    required this.kind,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.memberIds,
  });

  final RitualKind kind;
  final String title;
  final String description;
  final String actionLabel;
  final List<String> memberIds;

  @override
  List<Object?> get props => <Object?>[
    kind,
    title,
    description,
    actionLabel,
    memberIds,
  ];
}
