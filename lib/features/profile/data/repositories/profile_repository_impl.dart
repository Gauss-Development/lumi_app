import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:lumi/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lumi/features/profile/data/models/user_profile_model.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final ProfileLocalDataSource _localDataSource;
  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, UserProfile?>> getProfile({String? userId}) async {
    try {
      if (userId != null && userId.isNotEmpty) {
        final UserProfile? remote = await _remoteDataSource.fetchProfile(userId);
        if (remote != null) {
          await _localDataSource.saveProfile(
            UserProfileModel.fromEntity(remote),
          );
          return Right(remote);
        }
      }
      return Right(await _localDataSource.getProfile());
    } on ProfileRemoteDataSourceException catch (_) {
      final UserProfile? cached = await _localDataSource.getProfile();
      if (cached != null && (userId == null || cached.id == userId)) {
        return Right(cached);
      }
      return const Left(ServerFailure('Unable to load profile from cloud.'));
    } catch (_) {
      final UserProfile? cached = await _localDataSource.getProfile();
      if (cached != null && (userId == null || cached.id == userId)) {
        return Right(cached);
      }
      return const Left(UnexpectedFailure('Unable to load profile.'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> saveProfile(UserProfile profile) async {
    try {
      final UserProfileModel model = UserProfileModel.fromEntity(profile);
      await _localDataSource.saveProfile(model);
      if (profile.id.isNotEmpty) {
        await _remoteDataSource.upsertProfile(profile);
      }
      return Right(model);
    } on ProfileRemoteDataSourceException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to save profile.'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateSignatureColor({
    required String userId,
    required int signatureColorValue,
  }) async {
    try {
      final UserProfile? existing = await _localDataSource.getProfile();
      if (existing == null || existing.id != userId) {
        return const Left(ServerFailure('Profile not found.'));
      }

      final UserProfile updated = existing.copyWith(
        signatureColorValue: signatureColorValue,
      );
      await _localDataSource.saveProfile(UserProfileModel.fromEntity(updated));
      await _remoteDataSource.upsertProfile(updated);
      return Right(updated);
    } on ProfileRemoteDataSourceException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to update signature color.'));
    }
  }
}
