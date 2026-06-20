import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

/// Latest incoming Lumi receipt time per circle member id.
Map<String, DateTime> latestIncomingReceiptByMemberId(List<Lumi> items) {
  final Map<String, DateTime> latest = <String, DateTime>{};
  for (final Lumi lumi in items) {
    if (!lumi.isIncoming) {
      continue;
    }
    final DateTime? existing = latest[lumi.memberId];
    if (existing == null || lumi.createdAt.isAfter(existing)) {
      latest[lumi.memberId] = lumi.createdAt;
    }
  }
  return latest;
}

bool memberNameGlowActive(DateTime? receivedAt, DateTime now) {
  if (receivedAt == null) {
    return false;
  }
  return now.difference(receivedAt).inHours < LumiLimits.nameGlowHours;
}
