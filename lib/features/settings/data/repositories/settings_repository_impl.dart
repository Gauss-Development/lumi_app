import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, LumiSettings>> getSettings() async {
    try {
      return Right(await _localDataSource.getSettings());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to load Lumi settings.'));
    }
  }

  @override
  Future<Either<Failure, LumiSettings>> updateMutePreferences({
    required bool notificationsEnabled,
    required bool hapticsEnabled,
  }) async {
    try {
      return Right(
        await _localDataSource.updatePreferences(
          notificationsEnabled: notificationsEnabled,
          hapticsEnabled: hapticsEnabled,
        ),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to update notification settings.'),
      );
    }
  }

  @override
  Future<Either<Failure, LumiSettings>> updateQuietHours(
    QuietHours quietHours,
  ) async {
    try {
      return Right(await _localDataSource.saveQuietHours(quietHours));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to save quiet hours.'));
    }
  }
}
