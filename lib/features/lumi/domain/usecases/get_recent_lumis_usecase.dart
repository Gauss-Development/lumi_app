import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class GetRecentLumisUseCase {
  const GetRecentLumisUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, List<Lumi>>> call({String? memberId}) {
    return _repository.getRecentLumis(memberId: memberId);
  }
}
