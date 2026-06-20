import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/utils/phone_utils.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/entities/phone_otp_challenge.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_phone_otp_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/verify_phone_otp_usecase.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentSessionUseCase getCurrentSessionUseCase,
    required RequestPhoneOtpUseCase requestPhoneOtpUseCase,
    required VerifyPhoneOtpUseCase verifyPhoneOtpUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _requestPhoneOtpUseCase = requestPhoneOtpUseCase,
       _verifyPhoneOtpUseCase = verifyPhoneOtpUseCase,
       _signInWithEmailUseCase = signInWithEmailUseCase,
       _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_PhoneOtpRequested>(_onPhoneOtpRequested);
    on<_PhoneOtpVerified>(_onPhoneOtpVerified);
    on<_PhoneOtpCancelled>(_onPhoneOtpCancelled);
    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_GoogleSignInRequested>(_onGoogleSignInRequested);
    on<_SignedOut>(_onSignedOut);
  }

  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final RequestPhoneOtpUseCase _requestPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase _verifyPhoneOtpUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> _onStarted(_Started event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _getCurrentSessionUseCase();
    result.fold(
      (failure) => emit(AuthState.unauthenticated(failure.message)),
      (session) => session == null
          ? emit(const AuthState.unauthenticated())
          : emit(AuthState.authenticated(session)),
    );
  }

  Future<void> _onPhoneOtpRequested(
    _PhoneOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final String phone = PhoneUtils.normalizeToE164(event.phone);
    if (!PhoneUtils.isValidE164(phone)) {
      emit(const AuthState.failure('Enter a valid phone number.'));
      emit(const AuthState.unauthenticated());
      return;
    }

    final result = await _requestPhoneOtpUseCase(phone: phone);
    result.fold(
      (failure) {
        emit(AuthState.failure(failure.message));
        emit(const AuthState.unauthenticated());
      },
      (PhoneOtpChallenge challenge) =>
          emit(AuthState.otpVerification(challenge)),
    );
  }

  Future<void> _onPhoneOtpVerified(
    _PhoneOtpVerified event,
    Emitter<AuthState> emit,
  ) async {
    final PhoneOtpChallenge? challenge = state.maybeWhen(
      otpVerification: (PhoneOtpChallenge value) => value,
      orElse: () => null,
    );
    if (challenge == null) {
      return;
    }

    final result = await _verifyPhoneOtpUseCase(
      userId: challenge.userId,
      otp: event.otp,
    );
    result.fold(
      (failure) {
        emit(AuthState.failure(failure.message));
        emit(AuthState.otpVerification(challenge));
      },
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  void _onPhoneOtpCancelled(
    _PhoneOtpCancelled event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onSignInRequested(
    _SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signInWithEmailUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  Future<void> _onSignUpRequested(
    _SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signUpWithEmailUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  Future<void> _onGoogleSignInRequested(
    _GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogleUseCase();
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  Future<void> _onSignedOut(_SignedOut event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;
  const factory AuthEvent.phoneOtpRequested({required String phone}) =
      _PhoneOtpRequested;
  const factory AuthEvent.phoneOtpVerified({required String otp}) =
      _PhoneOtpVerified;
  const factory AuthEvent.phoneOtpCancelled() = _PhoneOtpCancelled;
  const factory AuthEvent.signInRequested({
    required String email,
    required String password,
  }) = _SignInRequested;
  const factory AuthEvent.signUpRequested({
    required String email,
    required String password,
    required String name,
  }) = _SignUpRequested;
  const factory AuthEvent.googleSignInRequested() = _GoogleSignInRequested;
  const factory AuthEvent.signedOut() = _SignedOut;
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated([String? message]) = _Unauthenticated;
  const factory AuthState.otpVerification(PhoneOtpChallenge challenge) =
      _OtpVerification;
  const factory AuthState.authenticated(AuthSession session) = _Authenticated;
  const factory AuthState.failure(String message) = _Failure;
}
