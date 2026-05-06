import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';

class _MockGetCurrentSessionUseCase extends Mock
    implements GetCurrentSessionUseCase {}

class _MockRequestOtpUseCase extends Mock implements RequestOtpUseCase {}

class _MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late GetCurrentSessionUseCase getCurrentSessionUseCase;
  late RequestOtpUseCase requestOtpUseCase;
  late VerifyOtpUseCase verifyOtpUseCase;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    getCurrentSessionUseCase = _MockGetCurrentSessionUseCase();
    requestOtpUseCase = _MockRequestOtpUseCase();
    verifyOtpUseCase = _MockVerifyOtpUseCase();
    signOutUseCase = _MockSignOutUseCase();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      getCurrentSessionUseCase: getCurrentSessionUseCase,
      requestOtpUseCase: requestOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      signOutUseCase: signOutUseCase,
    );
  }

  blocTest<AuthBloc, AuthState>(
    'emits loading then codeSent when otp request succeeds',
    build: () {
      when(
        () => requestOtpUseCase.call(any()),
      ).thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    act: (AuthBloc bloc) =>
        bloc.add(const AuthEvent.otpRequested('+15551112233')),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.codeSent('+15551112233'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when otp verification succeeds',
    build: () {
      when(
        () => verifyOtpUseCase.call(
          phoneNumber: any(named: 'phoneNumber'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          AuthSession(
            userId: 'demo-user',
            phoneNumber: '+15551112233',
            isDemo: true,
          ),
        ),
      );
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.otpVerified(phoneNumber: '+15551112233', code: '123456'),
    ),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(
        AuthSession(
          userId: 'demo-user',
          phoneNumber: '+15551112233',
          isDemo: true,
        ),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then failure when otp request fails',
    build: () {
      when(() => requestOtpUseCase.call(any())).thenAnswer(
        (_) async => const Left(
          AuthFailure('We could not send your Lumi sign-in code.'),
        ),
      );
      return buildBloc();
    },
    act: (AuthBloc bloc) =>
        bloc.add(const AuthEvent.otpRequested('+15551112233')),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.failure('We could not send your Lumi sign-in code.'),
    ],
  );
}
