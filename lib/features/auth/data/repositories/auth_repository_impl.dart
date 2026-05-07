import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthSession?>> getCurrentSession() async {
    try {
      return Right(await _remoteDataSource.getCurrentSession());
    } catch (_) {
      return const Left(AuthFailure('Unable to restore your session.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.requestOtp(phoneNumber);
      return const Right(unit);
    } catch (_) {
      return const Left(
        AuthFailure('We could not send your Lumi sign-in code.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (_) {
      return const Left(AuthFailure('We could not sign you out right now.'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      return Right(
        await _remoteDataSource.verifyOtp(phoneNumber: phoneNumber, code: code),
      );
    } catch (_) {
      return const Left(AuthFailure('That code did not work. Try again.'));
    }
  }
}
