import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';

class UpdateMutePreferencesUseCase {
  const UpdateMutePreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, LumiSettings>> call({
    required bool notificationsEnabled,
    required bool hapticsEnabled,
<<<<<<< HEAD
=======
    required bool appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  }) {
    return _repository.updateMutePreferences(
      notificationsEnabled: notificationsEnabled,
      hapticsEnabled: hapticsEnabled,
<<<<<<< HEAD
=======
      appPaused: appPaused,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }
}
