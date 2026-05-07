enum Flavor { development, production }

extension FlavorX on Flavor {
  String get envAssetName => assetEnvFileName;

  String get assetEnvFileName {
    switch (this) {
      case Flavor.development:
        return 'assets/env/.env.development';
      case Flavor.production:
        return 'assets/env/.env.production';
    }
  }

  String get name {
    switch (this) {
      case Flavor.development:
        return 'development';
      case Flavor.production:
        return 'production';
    }
  }
}
