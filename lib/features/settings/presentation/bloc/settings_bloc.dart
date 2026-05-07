import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:lumi/features/settings/domain/usecases/update_mute_preferences_usecase.dart';
import 'package:lumi/features/settings/domain/usecases/update_quiet_hours_usecase.dart';

part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettingsUseCase getSettings,
    required UpdateQuietHoursUseCase updateQuietHours,
    required UpdateMutePreferencesUseCase updatePreferences,
  }) : _getSettings = getSettings,
       _updateQuietHours = updateQuietHours,
       _updatePreferences = updatePreferences,
       super(
         const SettingsState(
           quietHours: QuietHours(
             startHour: 22,
             startMinute: 0,
             endHour: 8,
             endMinute: 0,
           ),
         ),
       ) {
    on<_LoadRequested>(_onLoadRequested);
    on<_QuietHoursUpdated>(_onQuietHoursUpdated);
    on<_NotificationsToggled>(_onNotificationsToggled);
    on<_HapticsToggled>(_onHapticsToggled);
  }

  final GetSettingsUseCase _getSettings;
  final UpdateQuietHoursUseCase _updateQuietHours;
  final UpdateMutePreferencesUseCase _updatePreferences;

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getSettings();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (settings) => emit(
        state.copyWith(
          isLoading: false,
          quietHours: settings.quietHours,
          notificationsEnabled: settings.notificationsEnabled,
          hapticsEnabled: settings.hapticsEnabled,
        ),
      ),
    );
  }

  Future<void> _onQuietHoursUpdated(
    _QuietHoursUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _updateQuietHours(event.quietHours);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (settings) => emit(
        state.copyWith(
          quietHours: settings.quietHours,
          notificationsEnabled: settings.notificationsEnabled,
          hapticsEnabled: settings.hapticsEnabled,
        ),
      ),
    );
  }

  Future<void> _onNotificationsToggled(
    _NotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _updatePreferences(
      notificationsEnabled: event.enabled,
      hapticsEnabled: state.hapticsEnabled,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (settings) => emit(
        state.copyWith(
          notificationsEnabled: settings.notificationsEnabled,
          hapticsEnabled: settings.hapticsEnabled,
        ),
      ),
    );
  }

  Future<void> _onHapticsToggled(
    _HapticsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _updatePreferences(
      notificationsEnabled: state.notificationsEnabled,
      hapticsEnabled: event.enabled,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (settings) => emit(
        state.copyWith(
          notificationsEnabled: settings.notificationsEnabled,
          hapticsEnabled: settings.hapticsEnabled,
        ),
      ),
    );
  }
}

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadRequested() = _LoadRequested;
  const factory SettingsEvent.quietHoursUpdated(QuietHours quietHours) =
      _QuietHoursUpdated;
  const factory SettingsEvent.notificationsToggled(bool enabled) =
      _NotificationsToggled;
  const factory SettingsEvent.hapticsToggled(bool enabled) = _HapticsToggled;
}

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required QuietHours quietHours,
    @Default(false) bool isLoading,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool hapticsEnabled,
    String? errorMessage,
  }) = _SettingsState;
}
