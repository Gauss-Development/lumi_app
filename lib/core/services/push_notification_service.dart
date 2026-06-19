import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/firebase_options_factory.dart';
import 'package:lumi/core/network/appwrite_client.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/services/member_haptic_preferences_service.dart';
import 'package:lumi/core/services/notification_service.dart';
import 'package:lumi/core/services/pending_lumi_notification_service.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/core/utils/lumi_push_payload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseOptions? options = FirebaseOptionsFactory.currentPlatform;
  if (options == null) {
    return;
  }
  await Firebase.initializeApp(options: options);
}

typedef PushNotificationTapCallback = void Function(LumiPushPayload payload);

class PushNotificationService {
  PushNotificationService({
    required NotificationService notificationService,
    required PendingLumiNotificationService pendingLumiNotificationService,
    required PreferencesService preferencesService,
    required HapticsService hapticsService,
    required MemberHapticPreferencesService memberHapticPreferencesService,
    Account? account,
    FirebaseMessaging? messaging,
  }) : _notificationService = notificationService,
       _pendingLumiNotificationService = pendingLumiNotificationService,
       _preferencesService = preferencesService,
       _hapticsService = hapticsService,
       _memberHapticPreferencesService = memberHapticPreferencesService,
       _account = account ?? Account(client),
       _messaging = messaging ?? FirebaseMessaging.instance;

  static const String _pushTargetIdKey = 'appwrite_push_target_id';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _hapticsEnabledKey = 'haptics_enabled';

  final NotificationService _notificationService;
  final PendingLumiNotificationService _pendingLumiNotificationService;
  final PreferencesService _preferencesService;
  final HapticsService _hapticsService;
  final MemberHapticPreferencesService _memberHapticPreferencesService;
  final Account _account;
  final FirebaseMessaging _messaging;

  bool _available = false;
  PushNotificationTapCallback? _onTap;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  bool get isAvailable => _available;

  void setOnTap(PushNotificationTapCallback? callback) {
    _onTap = callback;
  }

  Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    final FirebaseOptions? options = FirebaseOptionsFactory.currentPlatform;
    if (options == null) {
      return;
    }

    try {
      await Firebase.initializeApp(options: options);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _available = true;
    } catch (_) {
      return;
    }

    _notificationService.setNotificationTapHandler(_handleLocalNotificationTap);
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedMessage,
    );

    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleOpenedMessage(initialMessage);
    }
  }

  Future<void> registerForAuthenticatedUser() async {
    if (!_available || kIsWeb) {
      return;
    }
    if (!_preferencesService.readBool(
      _notificationsEnabledKey,
      fallback: true,
    )) {
      return;
    }

    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    final String? token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _upsertPushTarget(token);
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      _upsertPushTarget,
    );
  }

  Future<void> unregister() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    final String? targetId = _preferencesService.getString(_pushTargetIdKey);
    if (targetId == null || targetId.isEmpty) {
      return;
    }

    try {
      await _account.deletePushTarget(targetId: targetId);
    } on AppwriteException catch (_) {
      // Target may already be gone after sign-out.
    }

    await _preferencesService.remove(_pushTargetIdKey);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _foregroundSubscription = null;
    _openedAppSubscription = null;
  }

  Future<void> _upsertPushTarget(String token) async {
    final EnvironmentConfig config = EnvironmentConfig.instance;
    final String? providerId = config.appwriteFcmProviderId.isEmpty
        ? null
        : config.appwriteFcmProviderId;
    final String? existingTargetId = _preferencesService.getString(
      _pushTargetIdKey,
    );

    try {
      if (existingTargetId != null && existingTargetId.isNotEmpty) {
        await _account.updatePushTarget(
          targetId: existingTargetId,
          identifier: token,
        );
        return;
      }

      final String targetId = ID.unique();
      await _account.createPushTarget(
        targetId: targetId,
        identifier: token,
        providerId: providerId,
      );
      await _preferencesService.setString(_pushTargetIdKey, targetId);
    } on AppwriteException catch (error) {
      if (error.code == 409 && existingTargetId != null) {
        await _account.updatePushTarget(
          targetId: existingTargetId,
          identifier: token,
        );
        return;
      }
      if (existingTargetId != null) {
        await _preferencesService.remove(_pushTargetIdKey);
      }
      final String targetId = ID.unique();
      await _account.createPushTarget(
        targetId: targetId,
        identifier: token,
        providerId: providerId,
      );
      await _preferencesService.setString(_pushTargetIdKey, targetId);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!_preferencesService.readBool(
      _notificationsEnabledKey,
      fallback: true,
    )) {
      return;
    }

    final LumiPushPayload? payload = LumiPushPayload.fromData(message.data);
    if (payload == null) {
      return;
    }

    if (_preferencesService.readBool(_hapticsEnabledKey, fallback: true)) {
      if (payload.isReaction) {
        await _hapticsService.playSoftSelection();
      } else {
        final String? memberId = payload.recipientCircleMemberId;
        final pattern = _memberHapticPreferencesService.patternFor(
          memberId ?? '',
        );
        await _hapticsService.playSignatureIncoming(pattern);
      }
    }

    await _notificationService.showIncomingLumi(
      payload: payload,
      notificationId: _notificationIdFor(payload),
    );
    _onTap?.call(payload);
  }

  Future<void> _handleOpenedMessage(RemoteMessage message) async {
    final LumiPushPayload? payload = LumiPushPayload.fromData(message.data);
    if (payload == null) {
      return;
    }
    await _deliverTap(payload);
  }

  void _handleLocalNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }
    final Object? decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) {
      return;
    }
    final LumiPushPayload? pushPayload = LumiPushPayload.fromData(decoded);
    if (pushPayload == null) {
      return;
    }
    unawaited(_deliverTap(pushPayload));
  }

  Future<void> _deliverTap(LumiPushPayload payload) async {
    await _pendingLumiNotificationService.store(payload);
    _onTap?.call(payload);
  }

  int _notificationIdFor(LumiPushPayload payload) {
    final String seed = payload.lumiId ?? payload.senderMemberId ?? 'lumi';
    return seed.hashCode & 0x7fffffff;
  }
}
