import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class AcceptInvitationUseCase {
  const AcceptInvitationUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, CircleMember>> call(String inviteCode) {
    return _repository.acceptInvitation(inviteCode: inviteCode);
  }
}
