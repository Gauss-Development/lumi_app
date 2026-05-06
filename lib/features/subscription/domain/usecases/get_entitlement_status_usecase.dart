import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';

class GetEntitlementStatusUseCase {
  const GetEntitlementStatusUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<Either<Failure, EntitlementStatus>> call() {
    return _repository.getEntitlementStatus();
  }
}
