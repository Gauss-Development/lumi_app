import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';

/// Product rules for Glow+ vs free tier (MVP / GAU-287).
extension EntitlementFeatures on EntitlementStatus {
  static const int freeComposerColorCount = 3;

  bool get canUseGlowPlusModes => isActive;

  bool canSendLumiType(LumiType type) {
    if (type == LumiType.pure) {
      return true;
    }
    return isActive;
  }

  List<int> composerColorValues() {
    final List<int> values = AppConstants.signatureColors
        .map((color) => color.toARGB32())
        .toList(growable: false);
    if (isActive) {
      return values;
    }
    return values.take(freeComposerColorCount).toList(growable: false);
  }
}
