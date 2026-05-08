import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._preferencesService);

  final PreferencesService _preferencesService;

  Future<LumiSettings> getSettings() async {
    final quietHours = QuietHours(
      startHour: _preferencesService.readInt('quiet_start_hour') ?? 22,
      startMinute: _preferencesService.readInt('quiet_start_minute') ?? 0,
      endHour: _preferencesService.readInt('quiet_end_hour') ?? 8,
      endMinute: _preferencesService.readInt('quiet_end_minute') ?? 0,
      enabled: _preferencesService.readBool('quiet_enabled'),
    );

    return LumiSettings(
      quietHours: quietHours,
      notificationsEnabled: _preferencesService.readBool(
        'notifications_enabled',
      ),
      hapticsEnabled: _preferencesService.readBool('haptics_enabled'),
      appPaused: _preferencesService.readBool('app_paused'),
    );
  }

  Future<LumiSettings> saveQuietHours(QuietHours quietHours) async {
    await _preferencesService.writeInt(
      'quiet_start_hour',
      quietHours.startHour,
    );
    await _preferencesService.writeInt(
      'quiet_start_minute',
      quietHours.startMinute,
    );
    await _preferencesService.writeInt('quiet_end_hour', quietHours.endHour);
    await _preferencesService.writeInt(
      'quiet_end_minute',
      quietHours.endMinute,
    );
    await _preferencesService.writeBool('quiet_enabled', quietHours.enabled);

    final current = await getSettings();
    return current.copyWith(quietHours: quietHours);
  }

  Future<LumiSettings> updatePreferences({
    required bool notificationsEnabled,
    required bool hapticsEnabled,
    required bool appPaused,
  }) async {
    await _preferencesService.writeBool(
      'notifications_enabled',
      notificationsEnabled,
    );
    await _preferencesService.writeBool('haptics_enabled', hapticsEnabled);
    await _preferencesService.writeBool('app_paused', appPaused);

    final current = await getSettings();
    return current.copyWith(
      notificationsEnabled: notificationsEnabled,
      hapticsEnabled: hapticsEnabled,
      appPaused: appPaused,
    );
  }
}
