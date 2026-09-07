import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';

class _MockGetCurrentSessionUseCase extends Mock
    implements GetCurrentSessionUseCase {}

class _MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class _MockSignUpWithEmailUseCase extends Mock
    implements SignUpWithEmailUseCase {}

class _MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class _MockSignInWithAppleUseCase extends Mock
    implements SignInWithAppleUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

class _MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

class _MockRequestPasswordResetUseCase extends Mock
    implements RequestPasswordResetUseCase {}

void main() {
  late GetCurrentSessionUseCase getCurrentSessionUseCase;
  late SignInWithEmailUseCase signInWithEmailUseCase;
  late SignUpWithEmailUseCase signUpWithEmailUseCase;
  late SignInWithGoogleUseCase signInWithGoogleUseCase;
  late SignInWithAppleUseCase signInWithAppleUseCase;
  late SignOutUseCase signOutUseCase;
  late DeleteAccountUseCase deleteAccountUseCase;
  late RequestPasswordResetUseCase requestPasswordResetUseCase;

  const AuthSession session = AuthSession(
    userId: 'user-1',
    email: 'me@example.com',
  );

  setUp(() {
    getCurrentSessionUseCase = _MockGetCurrentSessionUseCase();
    signInWithEmailUseCase = _MockSignInWithEmailUseCase();
    signUpWithEmailUseCase = _MockSignUpWithEmailUseCase();
    signInWithGoogleUseCase = _MockSignInWithGoogleUseCase();
    signInWithAppleUseCase = _MockSignInWithAppleUseCase();
    signOutUseCase = _MockSignOutUseCase();
    deleteAccountUseCase = _MockDeleteAccountUseCase();
    requestPasswordResetUseCase = _MockRequestPasswordResetUseCase();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      getCurrentSessionUseCase: getCurrentSessionUseCase,
      signInWithEmailUseCase: signInWithEmailUseCase,
      signUpWithEmailUseCase: signUpWithEmailUseCase,
      signInWithGoogleUseCase: signInWithGoogleUseCase,
      signInWithAppleUseCase: signInWithAppleUseCase,
      signOutUseCase: signOutUseCase,
      deleteAccountUseCase: deleteAccountUseCase,
      requestPasswordResetUseCase: requestPasswordResetUseCase,
    );
  }

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when sign-in succeeds',
    build: () {
      when(
        () => signInWithEmailUseCase.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(session));
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
      const AuthState.authenticated(session),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when Google sign-in succeeds',
    build: () {
      when(
        () => signInWithGoogleUseCase(),
      ).thenAnswer((_) async => const Right(session));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(session),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when Apple sign-in succeeds',
    build: () {
      when(
        () => signInWithAppleUseCase(),
      ).thenAnswer((_) async => const Right(session));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.appleSignInRequested()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(session),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then unauthenticated when sign-out succeeds',
    build: () {
      when(() => signOutUseCase()).thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    seed: () => const AuthState.authenticated(session),
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.signedOut()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.unauthenticated(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure when sign-in fails',
    build: () {
      when(
        () => signInWithEmailUseCase.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.signInRequested(
        email: 'me@example.com',
        password: 'wrong',
      ),
    ),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.failure('Invalid credentials'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated with message when password reset succeeds',
    build: () {
      when(
        () => requestPasswordResetUseCase.call(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.passwordResetRequested(email: 'me@example.com'),
    ),
    expect: () => <AuthState>[
      const AuthState.unauthenticated(
        'Password reset email sent. Check your inbox.',
      ),
    ],
  );
}
