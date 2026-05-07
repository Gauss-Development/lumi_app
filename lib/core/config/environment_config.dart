import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:lumi/core/config/flavor.dart';

class EnvironmentConfig {
  EnvironmentConfig._({
    required this.flavor,
    required this.appName,
    required this.enableDemoMode,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.inviteBaseUrl,
    required this.revenueCatAppleKey,
    required this.revenueCatGoogleKey,
  });

  static late EnvironmentConfig instance;

  final Flavor flavor;
  final String appName;
  final bool enableDemoMode;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String inviteBaseUrl;
  final String revenueCatAppleKey;
  final String revenueCatGoogleKey;

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
      enableDemoMode: valueOf('ENABLE_DEMO_MODE').toLowerCase() == 'true',
      supabaseUrl: valueOf('SUPABASE_URL'),
      supabaseAnonKey: valueOf('SUPABASE_ANON_KEY'),
      inviteBaseUrl: valueOf('INVITE_BASE_URL').isEmpty
          ? 'https://lumi.family/invite'
          : valueOf('INVITE_BASE_URL'),
      revenueCatAppleKey: valueOf('REVENUECAT_APPLE_KEY'),
      revenueCatGoogleKey: valueOf('REVENUECAT_GOOGLE_KEY'),
    );

    config.validateRequired();
    instance = config;
    return config;
  }

  void validateRequired() {
    if (enableDemoMode) {
      return;
    }

    final missingKeys = <String>[
      if (supabaseUrl.isEmpty) 'SUPABASE_URL',
      if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
      if (revenueCatAppleKey.isEmpty && revenueCatGoogleKey.isEmpty)
        'REVENUECAT_APPLE_KEY or REVENUECAT_GOOGLE_KEY',
    ];

    if (missingKeys.isNotEmpty) {
      throw StateError(
        'Missing required environment values: ${missingKeys.join(', ')}. '
        'Add them to ${flavor.envAssetName} or provide --dart-define overrides.',
      );
    }
  }
}
