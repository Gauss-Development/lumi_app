import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class SendInviteUseCase {
  const SendInviteUseCase(this._repository);

  final CircleRepository _repository;

<<<<<<< HEAD
  Future<Either<Failure, CircleMember>> call(String displayName) {
    return _repository.sendInvite(displayName: displayName);
=======
  Future<Either<Failure, CircleMember>> call({
    required String displayName,
    String? relationshipLabel,
  }) {
    return _repository.sendInvite(
      displayName: displayName,
      relationshipLabel: relationshipLabel,
    );
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  }
}
