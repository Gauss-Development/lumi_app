import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:lumi/core/config/environment_config.dart';

class FirebaseOptionsFactory {
  const FirebaseOptionsFactory._();

  static bool get isConfigured {
    final EnvironmentConfig config = EnvironmentConfig.instance;
    return config.firebaseApiKey.isNotEmpty &&
        config.firebaseAppId.isNotEmpty &&
        config.firebaseMessagingSenderId.isNotEmpty &&
        config.firebaseProjectId.isNotEmpty;
  }

  static FirebaseOptions? get currentPlatform {
    if (!isConfigured) {
      return null;
    }

    final EnvironmentConfig config = EnvironmentConfig.instance;
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: config.firebaseApiKey,
        appId: config.firebaseAppId,
        messagingSenderId: config.firebaseMessagingSenderId,
        projectId: config.firebaseProjectId,
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
          iosBundleId: config.firebaseIosBundleId,
        );
      default:
        return null;
    }
  }
}
