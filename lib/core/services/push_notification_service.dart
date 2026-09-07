import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/config/firebase_options_factory.dart';
import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/core/services/haptics_service.dart';
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
typedef PushNotificationForegroundCallback =
    void Function(LumiPushPayload payload);

class PushNotificationService {
  PushNotificationService({
    required NotificationService notificationService,
    required PendingLumiNotificationService pendingLumiNotificationService,
    required PreferencesService preferencesService,
    required HapticsService hapticsService,
    SupabaseClient? supabaseClient,
    FirebaseMessaging? messaging,
  }) : _notificationService = notificationService,
       _pendingLumiNotificationService = pendingLumiNotificationService,
       _preferencesService = preferencesService,
       _hapticsService = hapticsService,
       _supabaseClient = supabaseClient,
       _messaging = messaging ?? FirebaseMessaging.instance;

  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _hapticsEnabledKey = 'haptics_enabled';

  final NotificationService _notificationService;
  final PendingLumiNotificationService _pendingLumiNotificationService;
  final PreferencesService _preferencesService;
  final HapticsService _hapticsService;
  final SupabaseClient? _supabaseClient;
  final FirebaseMessaging _messaging;

  bool _available = false;
  PushNotificationTapCallback? _onTap;
  PushNotificationForegroundCallback? _onForegroundMessage;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  bool get isAvailable => _available;

  SupabaseClient? get _client {
    if (_supabaseClient != null) {
      return _supabaseClient;
    }
    if (!isSupabaseConfigured) {
      return null;
    }
    try {
      return supabase;
    } catch (_) {
      return null;
    }
  }

  void setOnTap(PushNotificationTapCallback? callback) {
    _onTap = callback;
  }

  void setOnForegroundMessage(PushNotificationForegroundCallback? callback) {
    _onForegroundMessage = callback;
  }

  String get _notificationsKey =>
      _preferencesService.userScopedKey(_notificationsEnabledKey);

  String get _hapticsKey =>
      _preferencesService.userScopedKey(_hapticsEnabledKey);

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
    if (!_preferencesService.readBool(_notificationsKey, fallback: true)) {
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

    await _upsertPushToken(token);
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      _upsertPushToken,
    );
  }

  Future<void> unregister() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    final SupabaseClient? client = _client;
    final User? user = client?.auth.currentUser;
    if (client == null || user == null) {
      return;
    }

    try {
      await client.from('push_tokens').delete().eq('user_id', user.id);
    } catch (_) {
      // Token cleanup is best-effort on sign-out.
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _foregroundSubscription = null;
    _openedAppSubscription = null;
  }

  Future<void> _upsertPushToken(String token) async {
    final SupabaseClient? client = _client;
    final User? user = client?.auth.currentUser;
    if (client == null || user == null) {
      return;
    }

    final String platform = _platformLabel();
    try {
      await client.from('push_tokens').upsert(<String, dynamic>{
        'user_id': user.id,
        'fcm_token': token,
        'platform': platform,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id,fcm_token');
    } catch (_) {
      // Push registration must not block the app.
    }
  }

  String _platformLabel() {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    return 'unknown';
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!_preferencesService.readBool(_notificationsKey, fallback: true)) {
      return;
    }

    final LumiPushPayload? payload = LumiPushPayload.fromData(message.data);
    if (payload == null) {
      return;
    }

    if (_preferencesService.readBool(_hapticsKey, fallback: true)) {
      await _hapticsService.playIncomingLumi();
    }

    _onForegroundMessage?.call(payload);

    await _notificationService.showIncomingLumi(
      payload: payload,
      notificationId: _notificationIdFor(payload),
    );
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
