import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';
import 'package:lumi/features/settings/domain/usecases/update_quiet_hours_usecase.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;
  late UpdateQuietHoursUseCase useCase;

  setUp(() {
    repository = _MockSettingsRepository();
    useCase = UpdateQuietHoursUseCase(repository);
  });

  test('returns updated settings from repository', () async {
    const quietHours = QuietHours(
      startHour: 21,
      startMinute: 0,
      endHour: 8,
      endMinute: 0,
    );
    const settings = LumiSettings(
      quietHours: quietHours,
      notificationsEnabled: true,
      hapticsEnabled: true,
<<<<<<< HEAD
=======
      appPaused: false,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );

    when(
      () => repository.updateQuietHours(quietHours),
    ).thenAnswer((_) async => const Right(settings));

    final result = await useCase(quietHours);

    expect(result, const Right<Failure, LumiSettings>(settings));
  });
}
