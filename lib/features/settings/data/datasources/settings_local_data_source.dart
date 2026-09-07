import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._preferencesService);

  final PreferencesService _preferencesService;

  Future<LumiSettings> getSettings() async {
    final quietHours = QuietHours(
      startHour: _preferencesService.readInt(_key('quiet_start_hour')) ?? 22,
      startMinute: _preferencesService.readInt(_key('quiet_start_minute')) ?? 0,
      endHour: _preferencesService.readInt(_key('quiet_end_hour')) ?? 8,
      endMinute: _preferencesService.readInt(_key('quiet_end_minute')) ?? 0,
      enabled: _preferencesService.readBool(
        _key('quiet_enabled'),
        fallback: true,
      ),
    );

    return LumiSettings(
      quietHours: quietHours,
      notificationsEnabled: _preferencesService.readBool(
        _key('notifications_enabled'),
        fallback: true,
      ),
      hapticsEnabled: _preferencesService.readBool(
        _key('haptics_enabled'),
        fallback: true,
      ),
      appPaused: _preferencesService.readBool(_key('app_paused')),
    );
  }

  Future<LumiSettings> saveQuietHours(QuietHours quietHours) async {
    await _preferencesService.writeInt(
      _key('quiet_start_hour'),
      quietHours.startHour,
    );
    await _preferencesService.writeInt(
      _key('quiet_start_minute'),
      quietHours.startMinute,
    );
    await _preferencesService.writeInt(
      _key('quiet_end_hour'),
      quietHours.endHour,
    );
    await _preferencesService.writeInt(
      _key('quiet_end_minute'),
      quietHours.endMinute,
    );
    await _preferencesService.writeBool(
      _key('quiet_enabled'),
      quietHours.enabled,
    );

    final current = await getSettings();
    return current.copyWith(quietHours: quietHours);
  }

  Future<LumiSettings> updatePreferences({
    required bool notificationsEnabled,
    required bool hapticsEnabled,
    required bool appPaused,
  }) async {
    await _preferencesService.writeBool(
      _key('notifications_enabled'),
      notificationsEnabled,
    );
    await _preferencesService.writeBool(
      _key('haptics_enabled'),
      hapticsEnabled,
    );
    await _preferencesService.writeBool(_key('app_paused'), appPaused);

    final current = await getSettings();
    return current.copyWith(
      notificationsEnabled: notificationsEnabled,
      hapticsEnabled: hapticsEnabled,
      appPaused: appPaused,
    );
  }

  String _key(String key) => _preferencesService.userScopedKey(key);
}
