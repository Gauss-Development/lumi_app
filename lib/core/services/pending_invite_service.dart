import 'package:lumi/core/services/preferences_service.dart';

class PendingInviteService {
  PendingInviteService(this._preferencesService);

  static const String _pendingInviteCodeKey = 'pending_invite_code';

  final PreferencesService _preferencesService;

  Future<void> store(String code) {
    return _preferencesService.setString(
      _pendingInviteCodeKey,
      code.trim().toUpperCase(),
    );
  }

  String? peek() {
    final String? code = _preferencesService.getString(_pendingInviteCodeKey);
    if (code == null || code.isEmpty) {
      return null;
    }
    return code;
  }

  Future<String?> consume() async {
    final String? code = peek();
    if (code == null) {
      return null;
    }
    await _preferencesService.remove(_pendingInviteCodeKey);
    return code;
  }
}
