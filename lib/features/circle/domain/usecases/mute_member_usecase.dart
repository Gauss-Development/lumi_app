import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class MuteMemberUseCase {
  const MuteMemberUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, CircleMember>> call({
    required String memberId,
    required Duration duration,
  }) {
    return _repository.muteMember(
      memberId: memberId,
      until: DateTime.now().add(duration),
    );
  }
}
