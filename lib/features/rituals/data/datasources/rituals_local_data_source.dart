import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';

class RitualsLocalDataSource {
  RitualsLocalDataSource(this._preferencesService);

  static const String _key = 'ritual_preferences';

  final PreferencesService _preferencesService;

  Future<RitualPreferences> getPreferences() async {
    final Map<String, dynamic>? json = _preferencesService.getJson(_key);
    if (json == null) {
      return const RitualPreferences();
    }
    return RitualPreferences.fromJson(json);
  }

  Future<RitualPreferences> savePreferences(
    RitualPreferences preferences,
  ) async {
    await _preferencesService.setJson(_key, preferences.toJson());
    return preferences;
  }
}
