import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class SaveDoodleDraftUseCase {
  const SaveDoodleDraftUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, DoodleStroke>> call(DoodleStroke stroke) {
    return _repository.saveDoodleDraft(stroke);
  }
}
