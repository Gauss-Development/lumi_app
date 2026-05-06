import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';
import 'package:lumi/features/lumi/domain/usecases/send_lumi_usecase.dart';

class _MockLumiRepository extends Mock implements LumiRepository {}

void main() {
  late _MockLumiRepository repository;
  late SendLumiUseCase useCase;

  setUp(() {
    repository = _MockLumiRepository();
    useCase = SendLumiUseCase(repository);
  });

  test('delegates pure lumi payload to repository', () async {
    const params = SendLumiParams.pure(
      senderId: 'sarah',
      recipientId: 'mom',
      colorValue: 0xFFFF7D6B,
    );
    final expected = Lumi(
      id: 'lumi-1',
      senderId: 'sarah',
      memberId: 'mom',
      isIncoming: false,
      type: LumiType.pure,
      colorValue: 0xFFFF7D6B,
      createdAt: DateTime(2026),
    );

    when(
      () => repository.sendLumi(
        senderId: 'sarah',
        recipientId: 'mom',
        type: LumiType.pure,
        colorValue: 0xFFFF7D6B,
        intensity: 0.7,
        pulsePattern: null,
        doodleStroke: null,
      ),
    ).thenAnswer((_) async => Right(expected));

    final result = await useCase(params);

    expect(result, Right(expected));
    verify(
      () => repository.sendLumi(
        senderId: 'sarah',
        recipientId: 'mom',
        type: LumiType.pure,
        colorValue: 0xFFFF7D6B,
        intensity: 0.7,
        pulsePattern: null,
        doodleStroke: null,
      ),
    ).called(1);
  });
}
