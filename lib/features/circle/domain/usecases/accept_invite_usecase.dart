import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class AcceptInviteUseCase {
  const AcceptInviteUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, CircleMember>> call(String memberId) {
    return _repository.activateMember(memberId: memberId);
  }
}
