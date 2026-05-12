import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class CreateInvitationUseCase {
  const CreateInvitationUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, Invitation>> call({
    required String inviteeLabel,
    String? inviteeRelationshipLabel,
  }) {
    return _repository.createInvitation(
      inviteeLabel: inviteeLabel,
      inviteeRelationshipLabel: inviteeRelationshipLabel,
    );
  }
}
