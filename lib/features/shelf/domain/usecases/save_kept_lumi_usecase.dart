import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/domain/repositories/shelf_repository.dart';

class SaveKeptLumiUseCase {
  const SaveKeptLumiUseCase(this._repository);

  final ShelfRepository _repository;

  Future<Either<Failure, List<KeptLumi>>> call(KeptLumi keptLumi) {
    return _repository.saveKeptLumi(keptLumi);
  }
}
