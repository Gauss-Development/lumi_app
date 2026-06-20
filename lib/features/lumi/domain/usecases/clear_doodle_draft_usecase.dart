import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class ClearDoodleDraftUseCase {
  const ClearDoodleDraftUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, Unit>> call() {
    return _repository.clearDoodleDraft();
  }
}
