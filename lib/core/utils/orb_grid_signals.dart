import 'package:lumi/core/utils/lumi_receipt_glow.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

/// Per-member visual state for [OrbGrid] derived from recent Lumis.
class OrbGridSignals {
  const OrbGridSignals({
    this.unreadByMemberId = const <String, int>{},
    this.incomingTypeByMemberId = const <String, LumiType>{},
    this.nameGlowByMemberId = const <String, bool>{},
    this.reactionBadgeByMemberId = const <String, LumiReactionType>{},
  });

  final Map<String, int> unreadByMemberId;
  final Map<String, LumiType> incomingTypeByMemberId;
  final Map<String, bool> nameGlowByMemberId;
  final Map<String, LumiReactionType> reactionBadgeByMemberId;

  static OrbGridSignals fromLumis(List<Lumi> items, DateTime now) {
    final Map<String, int> unread = <String, int>{};
    final Map<String, LumiType> incomingTypes = <String, LumiType>{};
    final Map<String, LumiReactionType> reactionBadges =
        <String, LumiReactionType>{};

    final Map<String, DateTime> latestReceipt =
        latestIncomingReceiptByMemberId(items);

    for (final Lumi lumi in items) {
      if (lumi.isIncoming && !lumi.deliveryStatus.isIncomingSettled) {
        unread[lumi.memberId] = (unread[lumi.memberId] ?? 0) + 1;
        incomingTypes.putIfAbsent(lumi.memberId, () => lumi.type);
      }
      if (!lumi.isIncoming && lumi.hasReaction && lumi.reaction != null) {
        reactionBadges[lumi.memberId] = lumi.reaction!;
      }
    }

    final Map<String, bool> nameGlow = <String, bool>{};
    for (final MapEntry<String, DateTime> entry in latestReceipt.entries) {
      nameGlow[entry.key] = memberNameGlowActive(entry.value, now);
    }

    return OrbGridSignals(
      unreadByMemberId: unread,
      incomingTypeByMemberId: incomingTypes,
      nameGlowByMemberId: nameGlow,
      reactionBadgeByMemberId: reactionBadges,
    );
  }
}

/// Orb breathing parameters tuned per Lumi type.
extension LumiTypeOrbAnimation on LumiType {
  Duration get orbPulseDuration => switch (this) {
    LumiType.pulse => const Duration(milliseconds: 720),
    LumiType.light => const Duration(milliseconds: 2200),
    LumiType.doodle => const Duration(milliseconds: 1700),
    LumiType.pure => const Duration(milliseconds: 1400),
  };

  double get orbMaxScale => switch (this) {
    LumiType.pulse => 1.1,
    LumiType.light => 1.04,
    LumiType.doodle => 1.05,
    LumiType.pure => 1.06,
  };

  double get orbMaxIntensityMultiplier => switch (this) {
    LumiType.pulse => 1.28,
    LumiType.light => 1.14,
    LumiType.doodle => 1.18,
    LumiType.pure => 1.22,
  };
}
