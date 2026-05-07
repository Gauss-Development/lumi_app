import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/domain/repositories/profile_repository.dart';

class UpdateSignatureColorParams {
  const UpdateSignatureColorParams({
    required this.userId,
    required this.signatureColorValue,
  });

  final String userId;
  final int signatureColorValue;
}

class UpdateSignatureColorUseCase {
  const UpdateSignatureColorUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, UserProfile>> call(UpdateSignatureColorParams params) {
    return _repository.updateSignatureColor(
      userId: params.userId,
      signatureColorValue: params.signatureColorValue,
    );
  }
}
