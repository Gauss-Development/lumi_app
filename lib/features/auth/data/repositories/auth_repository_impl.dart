import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/domain/entities/phone_otp_challenge.dart';
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
  Future<Either<Failure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return Right(
        await _remoteDataSource.signInWithEmail(
          email: email,
          password: password,
        ),
      );
    } on AuthDataSourceException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('Could not sign you in. Try again.'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return Right(
        await _remoteDataSource.signUpWithEmail(
          email: email,
          password: password,
          name: name,
        ),
      );
    } on AuthDataSourceException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('Could not create your account.'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    try {
      return Right(await _remoteDataSource.signInWithGoogle());
    } on AuthDataSourceException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(
        AuthFailure('Google sign-in did not finish. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, PhoneOtpChallenge>> requestPhoneOtp({
    required String phone,
  }) async {
    try {
      return Right(await _remoteDataSource.requestPhoneOtp(phone: phone));
    } on AuthDataSourceException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(
        AuthFailure('Could not send a verification code. Try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyPhoneOtp({
    required String userId,
    required String otp,
  }) async {
    try {
      return Right(
        await _remoteDataSource.verifyPhoneOtp(userId: userId, otp: otp),
      );
    } on AuthDataSourceException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('That code did not work. Try again.'));
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
}
