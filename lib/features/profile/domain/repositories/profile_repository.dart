import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile?>> getProfile({String? userId});

  Future<Either<Failure, UserProfile>> saveProfile(UserProfile profile);

  Future<Either<Failure, UserProfile>> updateSignatureColor({
    required String userId,
    required int signatureColorValue,
  });
}
