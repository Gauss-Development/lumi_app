import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber);

  Future<Either<Failure, AuthSession>> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<Either<Failure, AuthSession?>> getCurrentSession();

  Future<Either<Failure, Unit>> signOut();
}
