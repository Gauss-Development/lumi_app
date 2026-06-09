import 'dart:io' show Platform;

import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/flavor.dart';

class RevenueCatService {
  RevenueCatService({required EnvironmentConfig config, required Flavor flavor})
    : _config = config,
      _flavor = flavor;

  static const String lumiPlusEntitlementId = 'lumi_plus';

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

  Future<CustomerInfo?> purchasePackage(Package package) async {
    if (!_isConfigured) {
      return null;
    }
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_isConfigured) {
      return null;
    }
    return Purchases.restorePurchases();
  }

  Future<void> logIn(String userId) async {
    if (!_isConfigured || userId.isEmpty) {
      return;
    }
    await Purchases.logIn(userId);
  }

  Future<void> logOut() async {
    if (!_isConfigured) {
      return;
    }
    await Purchases.logOut();
  }

  String? _resolveApiKey() {
    if (Platform.isIOS) {
      return _config.revenueCatAppleKey;
    }
    if (Platform.isAndroid) {
      return _config.revenueCatGoogleKey;
    }
    return null;
  }
}
