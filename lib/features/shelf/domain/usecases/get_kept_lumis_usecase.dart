import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/domain/repositories/shelf_repository.dart';

class GetKeptLumisUseCase {
  const GetKeptLumisUseCase(this._repository);

  final ShelfRepository _repository;

  Future<Either<Failure, List<KeptLumi>>> call() {
    return _repository.getKeptLumis();
  }
}
