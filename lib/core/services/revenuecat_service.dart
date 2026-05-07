import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/flavor.dart';

class RevenueCatService {
  RevenueCatService({required EnvironmentConfig config, required Flavor flavor})
    : _config = config,
      _flavor = flavor;

  final EnvironmentConfig _config;
  final Flavor _flavor;

  bool _isConfigured = false;

  Future<void> initialize() async {
    final apiKey = _resolveApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return;
    }

    await Purchases.setLogLevel(
      _flavor == Flavor.production ? LogLevel.warn : LogLevel.debug,
    );
    await Purchases.configure(PurchasesConfiguration(apiKey));
    _isConfigured = true;
  }

  bool get isConfigured => _isConfigured;

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_isConfigured) {
      return null;
    }
    return Purchases.getCustomerInfo();
  }

  Future<Offerings?> getOfferings() async {
    if (!_isConfigured) {
      return null;
    }
    return Purchases.getOfferings();
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_isConfigured) {
      return null;
    }
    return Purchases.restorePurchases();
  }

  String? _resolveApiKey() {
    return _config.revenueCatAppleKey.isNotEmpty
        ? _config.revenueCatAppleKey
        : _config.revenueCatGoogleKey;
  }
}
