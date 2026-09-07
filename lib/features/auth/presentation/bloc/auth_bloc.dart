import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_up_with_email_usecase.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentSessionUseCase getCurrentSessionUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInWithAppleUseCase signInWithAppleUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required RequestPasswordResetUseCase requestPasswordResetUseCase,
  }) : _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _signInWithEmailUseCase = signInWithEmailUseCase,
       _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _signInWithAppleUseCase = signInWithAppleUseCase,
       _signOutUseCase = signOutUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       _requestPasswordResetUseCase = requestPasswordResetUseCase,
       super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_GoogleSignInRequested>(_onGoogleSignInRequested);
    on<_AppleSignInRequested>(_onAppleSignInRequested);
    on<_SignedOut>(_onSignedOut);
    on<_DeleteAccountRequested>(_onDeleteAccountRequested);
    on<_PasswordResetRequested>(_onPasswordResetRequested);
  }

  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;
  final SignOutUseCase _signOutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;

  Future<void> _onStarted(_Started event, Emitter<AuthState> emit) async {
    final result = await _getCurrentSessionUseCase();
    result.fold(
      (failure) => emit(AuthState.unauthenticated(failure.message)),
      (session) => session == null
          ? emit(const AuthState.unauthenticated())
          : emit(AuthState.authenticated(session)),
    );
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

  Future<void> _onAppleSignInRequested(
    _AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signInWithAppleUseCase();
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  Future<void> _onSignedOut(_SignedOut event, Emitter<AuthState> emit) async {
    final AuthSession? previousSession = state.maybeWhen(
      authenticated: (AuthSession session) => session,
      orElse: () => null,
    );
    emit(const AuthState.loading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => previousSession == null
          ? emit(AuthState.failure(failure.message))
          : emit(AuthState.authenticated(previousSession)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onDeleteAccountRequested(
    _DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    final AuthSession? previousSession = state.maybeWhen(
      authenticated: (AuthSession session) => session,
      orElse: () => null,
    );
    emit(const AuthState.loading());
    final result = await _deleteAccountUseCase();
    result.fold(
      (failure) {
        emit(AuthState.failure(failure.message));
        if (previousSession != null) {
          emit(AuthState.authenticated(previousSession));
        }
      },
      (_) => emit(
        const AuthState.unauthenticated('Your account has been deleted.'),
      ),
    );
  }

  Future<void> _onPasswordResetRequested(
    _PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _requestPasswordResetUseCase(email: event.email);
    result.fold(
      (failure) {
        emit(AuthState.failure(failure.message));
        emit(const AuthState.unauthenticated());
      },
      (_) => emit(
        const AuthState.unauthenticated(
          'Password reset email sent. Check your inbox.',
        ),
      ),
    );
  }
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;
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
  const factory AuthEvent.appleSignInRequested() = _AppleSignInRequested;
  const factory AuthEvent.signedOut() = _SignedOut;
  const factory AuthEvent.deleteAccountRequested() = _DeleteAccountRequested;
  const factory AuthEvent.passwordResetRequested({required String email}) =
      _PasswordResetRequested;
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated([String? message]) = _Unauthenticated;
  const factory AuthState.authenticated(AuthSession session) = _Authenticated;
  const factory AuthState.failure(String message) = _Failure;
}
