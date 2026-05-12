import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:lumi/core/config/flavor.dart';

class EnvironmentConfig {
  EnvironmentConfig._({
    required this.flavor,
    required this.appName,
    required this.inviteBaseUrl,
    required this.revenueCatAppleKey,
    required this.revenueCatGoogleKey,
    required this.oauthRedirectUrl,
  });

  static late EnvironmentConfig instance;

  final Flavor flavor;
  final String appName;
  final String inviteBaseUrl;
  final String revenueCatAppleKey;
  final String revenueCatGoogleKey;
  final String oauthRedirectUrl;

  static Future<EnvironmentConfig> load({required Flavor flavor}) async {
    dotenv.clean();

    final candidates = <String>[
      flavor.envAssetName,
      'assets/env/.env',
      'assets/env/.env.example',
    ];

    for (final candidate in candidates) {
      try {
        await dotenv.load(fileName: candidate);
        break;
      } catch (_) {
        continue;
      }
    }

    String valueOf(String key) {
      final envValue = dotenv.maybeGet(key);
      if (envValue != null && envValue.isNotEmpty) {
        return envValue;
      }
      return '';
    }

    final config = EnvironmentConfig._(
      flavor: flavor,
      appName: valueOf('APP_NAME').isEmpty ? 'Lumi' : valueOf('APP_NAME'),
      inviteBaseUrl: valueOf('INVITE_BASE_URL').isEmpty
          ? 'https://lumi.family/invite'
          : valueOf('INVITE_BASE_URL'),
      revenueCatAppleKey: valueOf('REVENUECAT_APPLE_KEY'),
      revenueCatGoogleKey: valueOf('REVENUECAT_GOOGLE_KEY'),
      oauthRedirectUrl: valueOf('OAUTH_REDIRECT_URL').isEmpty
          ? 'appwrite-callback-69ff68eb0033441e4041'
          : valueOf('OAUTH_REDIRECT_URL'),
    );

    instance = config;
    return config;
  }
}
