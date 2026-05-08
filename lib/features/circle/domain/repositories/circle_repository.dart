import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

abstract class CircleRepository {
  Future<Either<Failure, List<CircleMember>>> getMembers();

  Future<Either<Failure, CircleMember>> sendInvite({
    required String displayName,
<<<<<<< HEAD
=======
    String? relationshipLabel,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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

<<<<<<< HEAD
=======
  Future<Either<Failure, CircleMember>> memorializeMember({
    required String memberId,
  });

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  Future<Either<Failure, int>> getAvailableSlots();
}
