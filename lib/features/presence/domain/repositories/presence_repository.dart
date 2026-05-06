import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';

abstract class PresenceRepository {
  Future<Either<Failure, PresenceSession>> recordHeartbeat();

  Future<Either<Failure, TogetherMoment?>> detectTogetherMoment();
}
