import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/core/utils/lumi_push_payload.dart';

class PendingLumiNotificationService {
  PendingLumiNotificationService(this._preferencesService);

  static const String _pendingLumiPushKey = 'pending_lumi_push';

  final PreferencesService _preferencesService;

  Future<void> store(LumiPushPayload payload) {
    return _preferencesService.setJson(
      _pendingLumiPushKey,
      payload.toStorageMap(),
    );
  }

  LumiPushPayload? peek() {
    return LumiPushPayload.fromStorageMap(
      _preferencesService.getJson(_pendingLumiPushKey),
    );
  }

  Future<LumiPushPayload?> consume() async {
    final LumiPushPayload? payload = peek();
    if (payload == null) {
      return null;
    }
    await _preferencesService.remove(_pendingLumiPushKey);
    return payload;
  }
}
