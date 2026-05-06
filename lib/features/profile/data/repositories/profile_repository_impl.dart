import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:lumi/features/profile/data/models/user_profile_model.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, UserProfile?>> getProfile() async {
    try {
      return Right(await _localDataSource.getProfile());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to load profile.'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> saveProfile(UserProfile profile) async {
    try {
      final UserProfileModel model = UserProfileModel.fromEntity(profile);
      await _localDataSource.saveProfile(model);
      return Right(model);
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
      return Right(updated);
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to update signature color.'));
    }
  }
}
