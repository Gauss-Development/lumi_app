import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:lumi/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:lumi/features/profile/domain/usecases/update_signature_color_usecase.dart';

part 'profile_setup_bloc.freezed.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc({
    required GetProfileUseCase getProfileUseCase,
    required SaveProfileUseCase saveProfileUseCase,
    required UpdateSignatureColorUseCase updateSignatureColorUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _saveProfileUseCase = saveProfileUseCase,
       _updateSignatureColorUseCase = updateSignatureColorUseCase,
       super(const ProfileSetupState()) {
    on<_Started>(_onStarted);
    on<_DisplayNameChanged>(_onDisplayNameChanged);
    on<_AvatarStyleChanged>(_onAvatarStyleChanged);
    on<_SignatureColorChanged>(_onSignatureColorChanged);
    on<_Submitted>(_onSubmitted);
    on<_Reset>(_onReset);
  }

  final GetProfileUseCase _getProfileUseCase;
  final SaveProfileUseCase _saveProfileUseCase;
  final UpdateSignatureColorUseCase _updateSignatureColorUseCase;

  Future<void> _onStarted(
    _Started event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(
      state.copyWith(status: ProfileSetupStatus.loading, errorMessage: null),
    );
    final result = await _getProfileUseCase(userId: event.userId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) {
        final String displayName = (profile?.displayName ?? '').trim().isNotEmpty
            ? profile!.displayName
            : (event.displayNameHint ?? '');
        emit(
          state.copyWith(
            status: ProfileSetupStatus.ready,
            displayName: displayName,
            avatarStyle: profile?.avatarStyle ?? UserProfile.avatarOptions.first,
            signatureColorValue:
                profile?.signatureColorValue ?? 0xFFFF7D6B,
            restoredFromCloud: profile != null,
          ),
        );
      },
    );
  }

  void _onDisplayNameChanged(
    _DisplayNameChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(displayName: event.value, errorMessage: null));
  }

  void _onAvatarStyleChanged(
    _AvatarStyleChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(avatarStyle: event.value));
  }

  Future<void> _onSignatureColorChanged(
    _SignatureColorChanged event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(state.copyWith(signatureColorValue: event.value));
    if (event.userId == null || event.userId!.isEmpty) {
      return;
    }
    await _updateSignatureColorUseCase(
      UpdateSignatureColorParams(
        userId: event.userId!,
        signatureColorValue: event.value,
      ),
    );
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(state.copyWith(status: ProfileSetupStatus.saving, errorMessage: null));
    final result = await _saveProfileUseCase(
      UserProfile(
        id: event.userId,
        displayName: state.displayName.trim(),
        avatarStyle: state.avatarStyle,
        signatureColorValue: state.signatureColorValue,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProfileSetupStatus.saved)),
    );
  }

  void _onReset(_Reset event, Emitter<ProfileSetupState> emit) {
    emit(const ProfileSetupState());
  }
}

enum ProfileSetupStatus { initial, loading, ready, saving, saved, failure }

@freezed
sealed class ProfileSetupEvent with _$ProfileSetupEvent {
  const factory ProfileSetupEvent.started({
    String? userId,
    String? displayNameHint,
  }) = _Started;
  const factory ProfileSetupEvent.displayNameChanged(String value) =
      _DisplayNameChanged;
  const factory ProfileSetupEvent.avatarStyleChanged(String value) =
      _AvatarStyleChanged;
  const factory ProfileSetupEvent.signatureColorChanged(
    int value, {
    String? userId,
  }) = _SignatureColorChanged;
  const factory ProfileSetupEvent.submitted({required String userId}) =
      _Submitted;
  const factory ProfileSetupEvent.reset() = _Reset;
}

@freezed
sealed class ProfileSetupState with _$ProfileSetupState {
  const ProfileSetupState._();

  const factory ProfileSetupState({
    @Default(ProfileSetupStatus.initial) ProfileSetupStatus status,
    @Default('') String displayName,
    @Default('avatar_0') String avatarStyle,
    @Default(0xFFFF7D6B) int signatureColorValue,
    @Default(false) bool restoredFromCloud,
    String? errorMessage,
  }) = _ProfileSetupState;

  bool get isSaving => status == ProfileSetupStatus.saving;
  bool get isSaved => status == ProfileSetupStatus.saved;
  bool get isProfileComplete => displayName.trim().isNotEmpty;
}
