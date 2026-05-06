import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';
import 'package:lumi/features/circle/domain/usecases/get_circle_members_usecase.dart';

class _MockCircleRepository extends Mock implements CircleRepository {}

void main() {
  late _MockCircleRepository repository;
  late GetCircleMembersUseCase useCase;

  setUp(() {
    repository = _MockCircleRepository();
    useCase = GetCircleMembersUseCase(repository);
  });

  test('returns members from repository', () async {
    const members = <CircleMember>[
      CircleMember(
        id: 'mom',
        displayName: 'Mom',
        signatureColorValue: 0xFFFFB347,
        status: CircleStatus.active,
        paceCount: 1,
        queuedCount: 0,
        mutualConnection: true,
      ),
    ];

    when(
      () => repository.getMembers(),
    ).thenAnswer((_) async => const Right(members));

    final result = await useCase();

    expect(result, const Right<dynamic, List<CircleMember>>(members));
    verify(() => repository.getMembers()).called(1);
  });
}
