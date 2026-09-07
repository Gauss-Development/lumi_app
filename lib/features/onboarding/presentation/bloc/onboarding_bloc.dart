import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/services/preferences_service.dart';

part 'onboarding_bloc.freezed.dart';

enum OnboardingStage { welcome, profile, permissions, onboarding, complete }

@freezed
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.started({required String userId}) = _Started;
  const factory OnboardingEvent.advance() = _Advance;
  const factory OnboardingEvent.back() = _Back;
  const factory OnboardingEvent.jumpTo(OnboardingStage stage) = _JumpTo;
  const factory OnboardingEvent.completeProfile() = _CompleteProfile;
  const factory OnboardingEvent.completePermissions({
    required bool notificationsGranted,
    required bool contactsGranted,
    required bool hapticsGranted,
  }) = _CompletePermissions;
  const factory OnboardingEvent.completeWalkthrough() = _CompleteWalkthrough;
  const factory OnboardingEvent.restoreForReturningUser() =
      _RestoreForReturningUser;
  const factory OnboardingEvent.reset() = _Reset;
}

@freezed
sealed class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(true) bool isResolving,
    String? userId,
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
    on<_CompleteWalkthrough>(_onCompleteWalkthrough);
    on<_RestoreForReturningUser>(_onRestoreForReturningUser);
    on<_Reset>(_onReset);
  }

  final PreferencesService _preferencesService;
  static const String _onboardingCompleteKeyPrefix = 'onboarding_complete';

  Future<void> _onStarted(_Started event, Emitter<OnboardingState> emit) async {
    final completed = _preferencesService.getBool(
      _onboardingCompleteKey(event.userId),
    );
    if (completed) {
      emit(
        state.copyWith(
          isResolving: false,
          userId: event.userId,
          stage: OnboardingStage.complete,
          completed: true,
        ),
      );
      return;
    }
    emit(
      OnboardingState(
        isResolving: false,
        userId: event.userId,
        stage: OnboardingStage.welcome,
      ),
    );
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
    emit(
      state.copyWith(
        stage: OnboardingStage.onboarding,
        notificationsGranted: event.notificationsGranted,
        contactsGranted: event.contactsGranted,
        hapticsGranted: event.hapticsGranted,
      ),
    );
  }

  Future<void> _onCompleteWalkthrough(
    _CompleteWalkthrough event,
    Emitter<OnboardingState> emit,
  ) async {
    await _markOnboardingComplete(emit);
  }

  Future<void> _onRestoreForReturningUser(
    _RestoreForReturningUser event,
    Emitter<OnboardingState> emit,
  ) async {
    await _markOnboardingComplete(emit);
  }

  void _onReset(_Reset event, Emitter<OnboardingState> emit) {
    emit(const OnboardingState(isResolving: false));
  }

  Future<void> _markOnboardingComplete(Emitter<OnboardingState> emit) async {
    final String? userId = state.userId;
    if (userId == null || userId.isEmpty) {
      emit(state.copyWith(isResolving: false));
      return;
    }
    await _preferencesService.setBool(_onboardingCompleteKey(userId), true);
    emit(
      state.copyWith(
        isResolving: false,
        stage: OnboardingStage.complete,
        completed: true,
        notificationsGranted: state.notificationsGranted,
        contactsGranted: state.contactsGranted,
        hapticsGranted: state.hapticsGranted,
      ),
    );
  }

  static String _onboardingCompleteKey(String userId) {
    return '${_onboardingCompleteKeyPrefix}_$userId';
  }
}
