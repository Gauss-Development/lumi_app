import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';
import 'package:lumi/features/presence/domain/repositories/presence_repository.dart';

class DetectTogetherMomentUseCase {
  const DetectTogetherMomentUseCase(this._repository);

  final PresenceRepository _repository;

  Future<Either<Failure, TogetherMoment?>> call() {
    return _repository.detectTogetherMoment();
  }
}
