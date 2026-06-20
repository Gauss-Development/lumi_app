import 'package:lumi/core/config/environment_config.dart';

class InviteLinkUtils {
  const InviteLinkUtils._();

  static String buildInviteUrl(String code) {
    final String base = EnvironmentConfig.instance.inviteBaseUrl
        .replaceAll(RegExp(r'/+$'), '');
    return '$base/${code.trim().toUpperCase()}';
  }

  static String? extractInviteCode(Uri uri) {
    if (uri.host.toLowerCase() == 'invite') {
      final List<String> hostPathSegments = uri.pathSegments
          .where((String segment) => segment.isNotEmpty)
          .toList(growable: false);
      if (hostPathSegments.isNotEmpty) {
        return hostPathSegments.first;
      }
    }

    final List<String> segments = uri.pathSegments
        .where((String segment) => segment.isNotEmpty)
        .toList(growable: false);
    if (segments.length >= 2 &&
        segments.first.toLowerCase() == 'invite' &&
        segments[1].isNotEmpty) {
      return segments[1];
    }
    if (segments.length == 1 && segments.first.toLowerCase() == 'invite') {
      final String? queryCode = uri.queryParameters['code'];
      if (queryCode != null && queryCode.isNotEmpty) {
        return queryCode;
      }
    }
    final String? queryCode = uri.queryParameters['code'];
    if (queryCode != null && queryCode.isNotEmpty) {
      return queryCode;
    }
    return null;
  }
}
