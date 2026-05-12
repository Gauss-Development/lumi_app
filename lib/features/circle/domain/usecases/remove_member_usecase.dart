import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class RemoveMemberUseCase {
  const RemoveMemberUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, Unit>> call({required String memberId}) {
    return _repository.removeMember(memberId: memberId);
  }
}
