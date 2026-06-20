import 'dart:async';

import 'package:app_links/app_links.dart';

import 'package:lumi/core/services/pending_invite_service.dart';
import 'package:lumi/core/utils/invite_link_utils.dart';

class InviteDeepLinkService {
  InviteDeepLinkService({
    required PendingInviteService pendingInviteService,
    AppLinks? appLinks,
  }) : _pendingInviteService = pendingInviteService,
       _appLinks = appLinks ?? AppLinks();

  final PendingInviteService _pendingInviteService;
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  Future<void> start() async {
    final Uri? initial = await _appLinks.getInitialLink();
    if (initial != null) {
      await _handleUri(initial);
    }
    await _subscription?.cancel();
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  Future<void> _handleUri(Uri uri) async {
    final String? code = InviteLinkUtils.extractInviteCode(uri);
    if (code == null || code.isEmpty) {
      return;
    }
    await _pendingInviteService.store(code);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
