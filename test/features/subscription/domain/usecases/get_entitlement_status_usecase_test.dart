import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:lumi/features/subscription/domain/usecases/get_entitlement_status_usecase.dart';

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late _MockSubscriptionRepository repository;
  late GetEntitlementStatusUseCase useCase;

  setUp(() {
    repository = _MockSubscriptionRepository();
    useCase = GetEntitlementStatusUseCase(repository);
  });

  test('returns subscription status from repository', () async {
    const EntitlementStatus status = EntitlementStatus.free();
    when(
      () => repository.getEntitlementStatus(),
    ).thenAnswer((_) async => const Right(status));

    final result = await useCase();

    expect(result, const Right<Failure, EntitlementStatus>(status));
    verify(() => repository.getEntitlementStatus()).called(1);
  });
}
