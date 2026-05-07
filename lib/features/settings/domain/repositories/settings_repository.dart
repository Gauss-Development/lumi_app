import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

abstract class SettingsRepository {
  Future<Either<Failure, LumiSettings>> getSettings();

  Future<Either<Failure, LumiSettings>> updateQuietHours(QuietHours quietHours);

  Future<Either<Failure, LumiSettings>> updateMutePreferences({
    required bool notificationsEnabled,
    required bool hapticsEnabled,
    required bool appPaused,
  });
}
