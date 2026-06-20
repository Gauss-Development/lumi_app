import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/entities/phone_otp_challenge.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_phone_otp_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';

class _MockGetCurrentSessionUseCase extends Mock
    implements GetCurrentSessionUseCase {}

class _MockRequestPhoneOtpUseCase extends Mock
    implements RequestPhoneOtpUseCase {}

class _MockVerifyPhoneOtpUseCase extends Mock implements VerifyPhoneOtpUseCase {}

class _MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class _MockSignUpWithEmailUseCase extends Mock
    implements SignUpWithEmailUseCase {}

class _MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late GetCurrentSessionUseCase getCurrentSessionUseCase;
  late RequestPhoneOtpUseCase requestPhoneOtpUseCase;
  late VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  late SignInWithEmailUseCase signInWithEmailUseCase;
  late SignUpWithEmailUseCase signUpWithEmailUseCase;
  late SignInWithGoogleUseCase signInWithGoogleUseCase;
  late SignOutUseCase signOutUseCase;

  const AuthSession phoneSession = AuthSession(
    userId: 'user-phone',
    phone: '+15551234567',
    name: 'Mom',
  );
  const PhoneOtpChallenge challenge = PhoneOtpChallenge(
    userId: 'user-phone',
    phone: '+15551234567',
  );

  setUp(() {
    getCurrentSessionUseCase = _MockGetCurrentSessionUseCase();
    requestPhoneOtpUseCase = _MockRequestPhoneOtpUseCase();
    verifyPhoneOtpUseCase = _MockVerifyPhoneOtpUseCase();
    signInWithEmailUseCase = _MockSignInWithEmailUseCase();
    signUpWithEmailUseCase = _MockSignUpWithEmailUseCase();
    signInWithGoogleUseCase = _MockSignInWithGoogleUseCase();
    signOutUseCase = _MockSignOutUseCase();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      getCurrentSessionUseCase: getCurrentSessionUseCase,
      requestPhoneOtpUseCase: requestPhoneOtpUseCase,
      verifyPhoneOtpUseCase: verifyPhoneOtpUseCase,
      signInWithEmailUseCase: signInWithEmailUseCase,
      signUpWithEmailUseCase: signUpWithEmailUseCase,
      signInWithGoogleUseCase: signInWithGoogleUseCase,
      signOutUseCase: signOutUseCase,
    );
  }

  blocTest<AuthBloc, AuthState>(
    'emits otp verification when phone OTP is requested',
    build: () {
      when(
        () => requestPhoneOtpUseCase(phone: any(named: 'phone')),
      ).thenAnswer((_) async => const Right(challenge));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.phoneOtpRequested(phone: '5551234567'),
    ),
    expect: () => <AuthState>[const AuthState.otpVerification(challenge)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits authenticated when phone OTP verification succeeds',
    build: () {
      when(
        () => verifyPhoneOtpUseCase(
          userId: any(named: 'userId'),
          otp: any(named: 'otp'),
        ),
      ).thenAnswer((_) async => const Right(phoneSession));
      return buildBloc();
    },
    seed: () => const AuthState.otpVerification(challenge),
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.phoneOtpVerified(otp: '123456')),
    expect: () => <AuthState>[const AuthState.authenticated(phoneSession)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure then otp verification when phone OTP verification fails',
    build: () {
      when(
        () => verifyPhoneOtpUseCase(
          userId: any(named: 'userId'),
          otp: any(named: 'otp'),
        ),
      ).thenAnswer((_) async => const Left(AuthFailure('Invalid code')));
      return buildBloc();
    },
    seed: () => const AuthState.otpVerification(challenge),
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.phoneOtpVerified(otp: '000000')),
    expect: () => <AuthState>[
      const AuthState.failure('Invalid code'),
      const AuthState.otpVerification(challenge),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when sign-in succeeds',
    build: () {
      when(
        () => signInWithEmailUseCase.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          AuthSession(userId: 'user-1', email: 'me@example.com'),
        ),
      );
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.signInRequested(
        email: 'me@example.com',
        password: 'hunter2',
      ),
    ),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(
        AuthSession(userId: 'user-1', email: 'me@example.com'),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then unauthenticated when sign-out succeeds',
    build: () {
      when(() => signOutUseCase()).thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    seed: () => const AuthState.authenticated(
      AuthSession(userId: 'user-1', email: 'me@example.com'),
    ),
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.signedOut()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.unauthenticated(),
    ],
  );
}
