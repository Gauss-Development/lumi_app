import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class ReactToLumiUseCase {
  const ReactToLumiUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, Lumi>> call({
    required String lumiId,
    required LumiReactionType reaction,
  }) {
    return _repository.reactToLumi(lumiId: lumiId, reaction: reaction);
  }
}
