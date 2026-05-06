import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class CreateInviteLinkUseCase {
  const CreateInviteLinkUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, InviteLink>> call(String displayName) {
    return _repository.createInviteLink(displayName: displayName);
  }
}
