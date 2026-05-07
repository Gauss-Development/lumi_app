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
    required bool appPaused,
  }) {
    return _repository.updateMutePreferences(
      notificationsEnabled: notificationsEnabled,
      hapticsEnabled: hapticsEnabled,
      appPaused: appPaused,
    );
  }
}
