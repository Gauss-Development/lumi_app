import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

abstract class CircleRepository {
  Future<Either<Failure, List<CircleMember>>> getMembers();

  Future<Either<Failure, CircleMember>> sendInvite({
    required String displayName,
    String? relationshipLabel,
  });

  Future<Either<Failure, InviteLink>> createInviteLink({
    required String displayName,
  });

  Future<Either<Failure, CircleMember>> activateMember({
    required String memberId,
  });

  Future<Either<Failure, CircleMember>> muteMember({
    required String memberId,
    required DateTime until,
  });

  Future<Either<Failure, int>> getAvailableSlots();
}
