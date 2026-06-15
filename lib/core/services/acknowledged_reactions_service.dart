import 'package:flutter/foundation.dart';

import 'package:lumi/core/services/preferences_service.dart';

/// Tracks which outgoing Lumi reactions the sender has already seen in-app.
class AcknowledgedReactionsService extends ChangeNotifier {
  AcknowledgedReactionsService(this._preferencesService);

  static const String _storageKey = 'acknowledged_reaction_lumi_ids';

  final PreferencesService _preferencesService;
  Set<String> _acknowledgedIds = <String>{};
  bool _loaded = false;

  Set<String> get acknowledgedIds => Set<String>.unmodifiable(_acknowledgedIds);

  Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }
    _acknowledgedIds = _preferencesService
        .getStringList(_storageKey)
        .toSet();
    _loaded = true;
  }

  bool isAcknowledged(String lumiId) => _acknowledgedIds.contains(lumiId);

  Future<void> acknowledge(String lumiId) async {
    await ensureLoaded();
    if (_acknowledgedIds.contains(lumiId)) {
      return;
    }
    _acknowledgedIds = <String>{..._acknowledgedIds, lumiId};
    await _preferencesService.setStringList(
      _storageKey,
      _acknowledgedIds.toList(growable: false),
    );
    notifyListeners();
  }
}
