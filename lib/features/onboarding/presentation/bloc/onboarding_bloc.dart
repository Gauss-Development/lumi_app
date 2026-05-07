import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/services/preferences_service.dart';

part 'onboarding_bloc.freezed.dart';

enum OnboardingStage { welcome, phone, otp, profile, permissions, complete }

@freezed
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.started() = _Started;
  const factory OnboardingEvent.advance() = _Advance;
  const factory OnboardingEvent.back() = _Back;
  const factory OnboardingEvent.jumpTo(OnboardingStage stage) = _JumpTo;
  const factory OnboardingEvent.completeProfile() = _CompleteProfile;
  const factory OnboardingEvent.completePermissions({
    required bool notificationsGranted,
    required bool contactsGranted,
    required bool hapticsGranted,
  }) = _CompletePermissions;
}

@freezed
sealed class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStage.welcome) OnboardingStage stage,
    @Default(false) bool completed,
    @Default(false) bool notificationsGranted,
    @Default(false) bool contactsGranted,
    @Default(false) bool hapticsGranted,
  }) = _OnboardingState;
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._preferencesService) : super(const OnboardingState()) {
    on<_Started>(_onStarted);
    on<_Advance>(_onAdvance);
    on<_Back>(_onBack);
    on<_JumpTo>(_onJumpTo);
    on<_CompleteProfile>(_onCompleteProfile);
    on<_CompletePermissions>(_onCompletePermissions);
  }

  final PreferencesService _preferencesService;
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<void> _onStarted(_Started event, Emitter<OnboardingState> emit) async {
    final completed = _preferencesService.getBool(_onboardingCompleteKey);
    if (completed) {
      emit(state.copyWith(stage: OnboardingStage.complete, completed: true));
    }
  }

  void _onAdvance(_Advance event, Emitter<OnboardingState> emit) {
    final nextIndex = state.stage.index + 1;
    final nextStage = nextIndex >= OnboardingStage.values.length
        ? OnboardingStage.complete
        : OnboardingStage.values[nextIndex];
    emit(state.copyWith(stage: nextStage));
  }

  void _onBack(_Back event, Emitter<OnboardingState> emit) {
    final previousIndex = state.stage.index - 1;
    final previousStage = previousIndex <= 0
        ? OnboardingStage.welcome
        : OnboardingStage.values[previousIndex];
    emit(state.copyWith(stage: previousStage));
  }

  void _onJumpTo(_JumpTo event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(stage: event.stage));
  }

  void _onCompleteProfile(
    _CompleteProfile event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(stage: OnboardingStage.permissions));
  }

  Future<void> _onCompletePermissions(
    _CompletePermissions event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferencesService.setBool(_onboardingCompleteKey, true);
    emit(
      state.copyWith(
        stage: OnboardingStage.complete,
        completed: true,
        notificationsGranted: event.notificationsGranted,
        contactsGranted: event.contactsGranted,
        hapticsGranted: event.hapticsGranted,
      ),
    );
  }
}
