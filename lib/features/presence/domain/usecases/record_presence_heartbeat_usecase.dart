import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';
import 'package:lumi/features/presence/domain/repositories/presence_repository.dart';

class RecordPresenceHeartbeatUseCase {
  const RecordPresenceHeartbeatUseCase(this._repository);

  final PresenceRepository _repository;

  Future<Either<Failure, PresenceSession>> call() {
    return _repository.recordHeartbeat();
  }
}
