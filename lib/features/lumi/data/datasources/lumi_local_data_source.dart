import 'dart:convert';

import 'package:lumi/core/services/preferences_service.dart';
<<<<<<< HEAD
=======
import 'package:lumi/features/circle/data/datasources/circle_local_data_source.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';

class LumiLocalDataSource {
<<<<<<< HEAD
  LumiLocalDataSource(this._preferencesService);

  final PreferencesService _preferencesService;
=======
  LumiLocalDataSource(this._preferencesService, this._circleLocalDataSource);

  final PreferencesService _preferencesService;
  final CircleLocalDataSource _circleLocalDataSource;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

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
<<<<<<< HEAD
  }) async {
    final queued = quietHours?.isActiveAt(DateTime.now()) ?? false;
=======
    bool forceQueued = false,
  }) async {
    final queued = forceQueued || (quietHours?.isActiveAt(DateTime.now()) ?? false);
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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
    final simulatedReply = Lumi(
      id: 'reply-${DateTime.now().microsecondsSinceEpoch + 1}',
      memberId: recipientId,
      senderId: recipientId,
      isIncoming: true,
<<<<<<< HEAD
      type: LumiType.pure,
=======
      type: type,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      colorValue: colorValue,
      createdAt: DateTime.now().add(const Duration(seconds: 4)),
      deliveryStatus: LumiDeliveryStatus.delivered,
      reaction: LumiReactionType.handOnHeart,
<<<<<<< HEAD
    );
    await saveAll(<Lumi>[simulatedReply, lumi, ...all]);
=======
      intensity: intensity,
      pulsePattern: pulsePattern,
      doodleStroke: doodleStroke,
    );
    await saveAll(<Lumi>[simulatedReply, lumi, ...all]);
    await _circleLocalDataSource.touchMemberActivity(
      memberId: recipientId,
      queued: queued,
    );
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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
}
