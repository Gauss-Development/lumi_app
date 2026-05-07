import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class MarkLumiSeenUseCase {
  const MarkLumiSeenUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, Lumi>> call(String lumiId) {
    return _repository.markSeen(lumiId);
  }
}
