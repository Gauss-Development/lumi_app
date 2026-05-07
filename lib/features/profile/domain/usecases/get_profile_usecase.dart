import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, UserProfile?>> call() {
    return _repository.getProfile();
  }
}
