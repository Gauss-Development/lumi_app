import 'package:equatable/equatable.dart';

class QuietHours extends Equatable {
  const QuietHours({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.enabled = true,
  });

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final bool enabled;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'enabled': enabled,
  };

  factory QuietHours.fromJson(Map<String, dynamic> json) => QuietHours(
    startHour: json['startHour'] as int? ?? 22,
    startMinute: json['startMinute'] as int? ?? 0,
    endHour: json['endHour'] as int? ?? 8,
    endMinute: json['endMinute'] as int? ?? 0,
    enabled: json['enabled'] as bool? ?? true,
  );

  QuietHours copyWith({
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    bool? enabled,
  }) {
    return QuietHours(
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      enabled: enabled ?? this.enabled,
    );
  }

  bool isActiveAt(DateTime dateTime) {
    if (!enabled) {
      return false;
    }

    final int minutes = dateTime.hour * 60 + dateTime.minute;
    final int start = startHour * 60 + startMinute;
    final int end = endHour * 60 + endMinute;

    if (start == end) {
      return true;
    }
    if (start < end) {
      return minutes >= start && minutes < end;
    }
    return minutes >= start || minutes < end;
  }

  @override
  List<Object?> get props => <Object?>[
    startHour,
    startMinute,
    endHour,
    endMinute,
    enabled,
  ];
}

class LumiSettings extends Equatable {
  const LumiSettings({
    required this.quietHours,
    required this.notificationsEnabled,
    required this.hapticsEnabled,
<<<<<<< HEAD
=======
    required this.appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  });

  final QuietHours quietHours;
  final bool notificationsEnabled;
  final bool hapticsEnabled;
<<<<<<< HEAD
=======
  final bool appPaused;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

  LumiSettings copyWith({
    QuietHours? quietHours,
    bool? notificationsEnabled,
    bool? hapticsEnabled,
<<<<<<< HEAD
=======
    bool? appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  }) {
    return LumiSettings(
      quietHours: quietHours ?? this.quietHours,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
<<<<<<< HEAD
=======
      appPaused: appPaused ?? this.appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }

  @override
  List<Object?> get props => <Object?>[
    quietHours,
    notificationsEnabled,
    hapticsEnabled,
<<<<<<< HEAD
=======
    appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  ];
}
