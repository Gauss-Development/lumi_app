import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentSessionUseCase getCurrentSessionUseCase,
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _requestOtpUseCase = requestOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_OtpRequested>(_onOtpRequested);
    on<_OtpVerified>(_onOtpVerified);
    on<_SignedOut>(_onSignedOut);
  }

  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
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

  Future<void> _onOtpRequested(
    _OtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _requestOtpUseCase(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (_) => emit(AuthState.codeSent(event.phoneNumber)),
    );
  }

  Future<void> _onOtpVerified(
    _OtpVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _verifyOtpUseCase(
      phoneNumber: event.phoneNumber,
      code: event.code,
    );
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
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;
  const factory AuthEvent.otpRequested(String phoneNumber) = _OtpRequested;
  const factory AuthEvent.otpVerified({
    required String phoneNumber,
    required String code,
  }) = _OtpVerified;
  const factory AuthEvent.signedOut() = _SignedOut;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated([String? message]) = _Unauthenticated;
  const factory AuthState.codeSent(String phoneNumber) = _CodeSent;
  const factory AuthState.authenticated(AuthSession session) = _Authenticated;
  const factory AuthState.failure(String message) = _Failure;
}
