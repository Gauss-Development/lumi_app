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
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
    required this.firebaseIosBundleId,
    required this.appwriteFcmProviderId,
  });

  static late EnvironmentConfig instance;

  final Flavor flavor;
  final String appName;
  final String inviteBaseUrl;
  final String revenueCatAppleKey;
  final String revenueCatGoogleKey;
  final String oauthRedirectUrl;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;
  final String firebaseIosBundleId;
  final String appwriteFcmProviderId;

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
      firebaseApiKey: valueOf('FIREBASE_API_KEY'),
      firebaseAppId: valueOf('FIREBASE_APP_ID'),
      firebaseMessagingSenderId: valueOf('FIREBASE_MESSAGING_SENDER_ID'),
      firebaseProjectId: valueOf('FIREBASE_PROJECT_ID'),
      firebaseIosBundleId: valueOf('FIREBASE_IOS_BUNDLE_ID'),
      appwriteFcmProviderId: valueOf('APPWRITE_FCM_PROVIDER_ID'),
    );

    instance = config;
    return config;
  }
}
