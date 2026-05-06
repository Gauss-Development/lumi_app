import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:lumi/features/shelf/domain/usecases/save_kept_lumi_usecase.dart';

class _MockShelfRepository extends Mock implements ShelfRepository {}

void main() {
  late ShelfRepository repository;
  late SaveKeptLumiUseCase useCase;

  final keptLumi = KeptLumi(
    id: 'kept-1',
    lumiId: 'lumi-1',
    senderId: 'mom',
    senderName: 'Mom',
    previewLabel: 'Pure Lumi',
    savedAt: DateTime.utc(2026, 5, 6),
  );

  setUp(() {
    repository = _MockShelfRepository();
    useCase = SaveKeptLumiUseCase(repository);
  });

  test('returns updated kept lumi collection', () async {
    when(
      () => repository.saveKeptLumi(keptLumi),
    ).thenAnswer((_) async => Right(<KeptLumi>[keptLumi]));

    final result = await useCase(keptLumi);

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => <KeptLumi>[]), <KeptLumi>[keptLumi]);
    verify(() => repository.saveKeptLumi(keptLumi)).called(1);
  });
}
