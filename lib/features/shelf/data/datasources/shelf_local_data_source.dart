import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';

class ShelfLocalDataSource {
  ShelfLocalDataSource(this._preferencesService);

  final PreferencesService _preferencesService;

  static const _storageKey = 'shelf_kept_lumis';

  Future<List<KeptLumi>> getAll() async {
    final rawValue = _preferencesService.readString(_storageKey);
    if (rawValue == null || rawValue.isEmpty) {
      return const <KeptLumi>[];
    }

    final decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map((json) => KeptLumi.fromJson(json as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> save(KeptLumi keptLumi) async {
    final current = await getAll();
    final deduped = current.where((item) => item.id != keptLumi.id).toList();
    await _persist(<KeptLumi>[keptLumi, ...deduped]);
  }

  Future<void> remove(String keptLumiId) async {
    final current = await getAll();
    await _persist(
      current.where((item) => item.id != keptLumiId).toList(growable: false),
    );
  }

  Future<void> _persist(List<KeptLumi> lumis) async {
    final encoded = jsonEncode(
      lumis.map((lumi) => lumi.toJson()).toList(growable: false),
    );
    await _preferencesService.writeString(_storageKey, encoded);
  }
}
