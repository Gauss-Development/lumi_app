import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';
import 'package:lumi/features/rituals/domain/repositories/rituals_repository.dart';

class RitualsCubit extends Cubit<RitualsState> {
  RitualsCubit(this._repository)
    : super(const RitualsState(preferences: RitualPreferences()));

  final RitualsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _repository.getPreferences();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (preferences) =>
          emit(state.copyWith(isLoading: false, preferences: preferences)),
    );
  }

  Future<void> setMorningEnabled(bool enabled) {
    return _save(state.preferences.copyWith(morningEnabled: enabled));
  }

  Future<void> setEveningEnabled(bool enabled) {
    return _save(state.preferences.copyWith(eveningEnabled: enabled));
  }

  Future<void> setGentleRemindersEnabled(bool enabled) {
    return _save(state.preferences.copyWith(gentleRemindersEnabled: enabled));
  }

  Future<void> setReminderCadenceDays(int days) {
    return _save(state.preferences.copyWith(reminderCadenceDays: days));
  }

  Future<void> markSent(RitualKind kind) {
    final DateTime now = DateTime.now();
    final RitualPreferences current = state.preferences;
    final RitualPreferences next = switch (kind) {
      RitualKind.morning => current.copyWith(lastMorningSentAt: now),
      RitualKind.evening => current.copyWith(lastEveningSentAt: now),
      RitualKind.checkIn => current.copyWith(lastCheckInSentAt: now),
    };
    return _save(next);
  }

  Future<void> dismissForToday() {
    final DateTime now = DateTime.now();
    final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    return _save(state.preferences.copyWith(dismissedUntil: tomorrow));
  }

  Future<void> _save(RitualPreferences preferences) async {
    emit(state.copyWith(preferences: preferences, errorMessage: null));
    final result = await _repository.savePreferences(preferences);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (saved) => emit(state.copyWith(preferences: saved)),
    );
  }
}

class RitualsState extends Equatable {
  const RitualsState({
    required this.preferences,
    this.isLoading = false,
    this.errorMessage,
  });

  final RitualPreferences preferences;
  final bool isLoading;
  final String? errorMessage;

  RitualsState copyWith({
    RitualPreferences? preferences,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RitualsState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[preferences, isLoading, errorMessage];
}
