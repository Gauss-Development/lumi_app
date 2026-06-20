import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

class LumiLocalDataSource {
  LumiLocalDataSource(this._preferencesService, this._circleRemoteDataSource);

  final PreferencesService _preferencesService;
  final CircleRemoteDataSource _circleRemoteDataSource;

  static const String _lumiKey = 'lumi_items';
  static const String _doodleDraftKey = 'doodle_draft';

  Future<List<Lumi>> fetchAll() async {
    final raw = _preferencesService.readString(_lumiKey);
    if (raw == null || raw.isEmpty) {
      return <Lumi>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Lumi.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveAll(List<Lumi> lumis) async {
    await _preferencesService.writeString(
      _lumiKey,
      jsonEncode(lumis.map((item) => item.toJson()).toList(growable: false)),
    );
  }

  Future<void> touchMemberActivity({
    required String memberId,
    required bool queued,
  }) {
    return _circleRemoteDataSource.touchMemberActivity(
      memberId: memberId,
      queued: queued,
    );
  }

  Future<List<Lumi>> getRecentLumis({String? memberId}) async {
    final all = await fetchAll();
    final filtered = memberId == null
        ? all
        : all
              .where((item) => item.memberId == memberId)
              .toList(growable: false);
    return filtered..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Lumi> sendLumi({
    required String senderId,
    required String recipientId,
    required LumiType type,
    required int colorValue,
    required double intensity,
    PulsePattern? pulsePattern,
    DoodleStroke? doodleStroke,
    QuietHours? quietHours,
    bool forceQueued = false,
  }) async {
    final queued =
        forceQueued || (quietHours?.isActiveAt(DateTime.now()) ?? false);
    final lumi = Lumi(
      id: 'lumi-${DateTime.now().microsecondsSinceEpoch}',
      memberId: recipientId,
      senderId: senderId,
      isIncoming: false,
      type: type,
      colorValue: colorValue,
      createdAt: DateTime.now(),
      intensity: intensity,
      deliveryStatus: queued
          ? LumiDeliveryStatus.queued
          : LumiDeliveryStatus.delivered,
      pulsePattern: pulsePattern,
      doodleStroke: doodleStroke,
    );

    final all = await fetchAll();
    await saveAll(<Lumi>[lumi, ...all]);
    await _circleRemoteDataSource.touchMemberActivity(
      memberId: recipientId,
      queued: queued,
    );
    return lumi;
  }

  Future<Lumi> reactToLumi({
    required String lumiId,
    required LumiReactionType reaction,
  }) async {
    final all = await fetchAll();
    late Lumi updated;
    final next = all
        .map((item) {
          if (item.id != lumiId) {
            return item;
          }

          updated = item.copyWith(
            reaction: reaction,
            deliveryStatus: LumiDeliveryStatus.reacted,
          );
          return updated;
        })
        .toList(growable: false);
    await saveAll(next);
    return updated;
  }

  Future<Lumi> markSeen(String lumiId) async {
    final all = await fetchAll();
    late Lumi updated;
    final next = all
        .map((item) {
          if (item.id != lumiId) {
            return item;
          }

          updated = item.copyWith(deliveryStatus: LumiDeliveryStatus.seen);
          return updated;
        })
        .toList(growable: false);
    await saveAll(next);
    return updated;
  }

  Future<DoodleStroke> saveDoodleDraft(DoodleStroke stroke) async {
    await _preferencesService.writeString(
      _doodleDraftKey,
      jsonEncode(stroke.toJson()),
    );
    return stroke;
  }

  Future<DoodleStroke?> loadDoodleDraft() async {
    final String? raw = _preferencesService.readString(_doodleDraftKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final Map<String, dynamic> decoded =
        jsonDecode(raw) as Map<String, dynamic>;
    return DoodleStroke.fromJson(decoded);
  }

  Future<void> clearDoodleDraft() {
    return _preferencesService.remove(_doodleDraftKey);
  }
}
