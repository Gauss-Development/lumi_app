import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession?>> getCurrentSession();

  Future<Either<Failure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthSession>> signInWithGoogle();

  Future<Either<Failure, Unit>> signOut();
}
