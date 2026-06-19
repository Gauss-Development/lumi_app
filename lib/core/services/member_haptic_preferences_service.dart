import 'package:flutter/foundation.dart';

import 'package:lumi/core/domain/entities/signature_haptic_pattern.dart';
import 'package:lumi/core/services/preferences_service.dart';

/// Local per-member incoming haptic preferences (device-only).
class MemberHapticPreferencesService extends ChangeNotifier {
  MemberHapticPreferencesService(this._preferencesService);

  static const String _storageKey = 'member_signature_haptic_patterns';

  final PreferencesService _preferencesService;
  Map<String, SignatureHapticPattern> _overrides =
      <String, SignatureHapticPattern>{};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }
    final Map<String, dynamic>? raw = _preferencesService.getJson(_storageKey);
    if (raw != null) {
      _overrides = raw.map(
        (String key, dynamic value) => MapEntry<String, SignatureHapticPattern>(
          key,
          SignatureHapticPattern.fromStorage(value as String?),
        ),
      );
    }
    _loaded = true;
  }

  SignatureHapticPattern patternFor(String memberId) {
    if (!_loaded) {
      return SignatureHapticPattern.defaultForMember(memberId);
    }
    return _overrides[memberId] ??
        SignatureHapticPattern.defaultForMember(memberId);
  }

  bool hasCustomPattern(String memberId) => _overrides.containsKey(memberId);

  Future<void> setPattern(
    String memberId,
    SignatureHapticPattern pattern,
  ) async {
    await ensureLoaded();
    _overrides = <String, SignatureHapticPattern>{
      ..._overrides,
      memberId: pattern,
    };
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _preferencesService.setJson(
      _storageKey,
      _overrides.map(
        (String key, SignatureHapticPattern value) =>
            MapEntry<String, dynamic>(key, value.storageKey),
      ),
    );
  }
}
