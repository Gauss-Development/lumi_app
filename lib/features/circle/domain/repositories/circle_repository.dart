import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';

abstract class CircleRepository {
  Future<Either<Failure, List<CircleMember>>> getMembers();

  Future<Either<Failure, Invitation>> createInvitation({
    required String inviteeLabel,
    String? inviteeRelationshipLabel,
  });

  Future<Either<Failure, CircleMember>> acceptInvitation({
    required String inviteCode,
  });

  Future<Either<Failure, CircleMember>> muteMember({
    required String memberId,
    required DateTime until,
  });

  Future<Either<Failure, CircleMember>> memorializeMember({
    required String memberId,
  });

  Future<Either<Failure, Unit>> removeMember({required String memberId});

  Future<Either<Failure, int>> getAvailableSlots();
}
