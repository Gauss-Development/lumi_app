class CacheException implements Exception {
  const CacheException(this.message);

  final String message;
}

class MissingConfigurationException implements Exception {
  const MissingConfigurationException(this.message);

  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);

  final String message;
}
