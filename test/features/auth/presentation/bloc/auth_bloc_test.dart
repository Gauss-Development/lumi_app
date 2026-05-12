import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
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

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late GetCurrentSessionUseCase getCurrentSessionUseCase;
  late SignInWithEmailUseCase signInWithEmailUseCase;
  late SignUpWithEmailUseCase signUpWithEmailUseCase;
  late SignInWithGoogleUseCase signInWithGoogleUseCase;
  late SignOutUseCase signOutUseCase;

  const AuthSession emailSession = AuthSession(
    userId: 'user-1',
    email: 'me@example.com',
  );
  const AuthSession googleSession = AuthSession(
    userId: 'user-google',
    email: 'me@gmail.com',
    name: 'Me',
    photoUrl: 'https://example.com/avatar.png',
  );

  setUp(() {
    getCurrentSessionUseCase = _MockGetCurrentSessionUseCase();
    signInWithEmailUseCase = _MockSignInWithEmailUseCase();
    signUpWithEmailUseCase = _MockSignUpWithEmailUseCase();
    signInWithGoogleUseCase = _MockSignInWithGoogleUseCase();
    signOutUseCase = _MockSignOutUseCase();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      getCurrentSessionUseCase: getCurrentSessionUseCase,
      signInWithEmailUseCase: signInWithEmailUseCase,
      signUpWithEmailUseCase: signUpWithEmailUseCase,
      signInWithGoogleUseCase: signInWithGoogleUseCase,
      signOutUseCase: signOutUseCase,
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
      ).thenAnswer((_) async => const Right(emailSession));
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
      const AuthState.authenticated(emailSession),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then failure when sign-in fails',
    build: () {
      when(
        () => signInWithEmailUseCase.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Left(AuthFailure('Invalid credentials.')),
      );
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
      const AuthState.failure('Invalid credentials.'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when sign-up succeeds',
    build: () {
      when(
        () => signUpWithEmailUseCase.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Right(emailSession));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(
      const AuthEvent.signUpRequested(
        email: 'me@example.com',
        password: 'hunter2',
        name: 'Me',
      ),
    ),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(emailSession),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when Google sign-in succeeds',
    build: () {
      when(() => signInWithGoogleUseCase.call())
          .thenAnswer((_) async => const Right(googleSession));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.authenticated(googleSession),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then failure when Google sign-in fails',
    build: () {
      when(() => signInWithGoogleUseCase.call()).thenAnswer(
        (_) async => const Left(
          AuthFailure('Google sign-in did not finish. Please try again.'),
        ),
      );
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.failure('Google sign-in did not finish. Please try again.'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then unauthenticated when sign-out succeeds',
    build: () {
      when(() => signOutUseCase.call())
          .thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    act: (AuthBloc bloc) => bloc.add(const AuthEvent.signedOut()),
    expect: () => <AuthState>[
      const AuthState.loading(),
      const AuthState.unauthenticated(),
    ],
  );
}
