import 'dart:convert';
import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:lumi/core/utils/lumi_push_payload.dart';

typedef NotificationTapHandler = void Function(String? payload);

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  NotificationTapHandler? _onNotificationTap;

  static const AndroidNotificationChannel morningGlowChannel =
      AndroidNotificationChannel(
        'morning_glow',
        'Morning glow deliveries',
        description: 'Batched Lumi deliveries sent after quiet hours.',
        importance: Importance.high,
      );

  static const AndroidNotificationChannel incomingLumiChannel =
      AndroidNotificationChannel(
        'lumi_incoming',
        'Incoming Lumi',
        description: 'Warm alerts when someone sends you a Lumi.',
        importance: Importance.high,
      );

  void setNotificationTapHandler(NotificationTapHandler? handler) {
    _onNotificationTap = handler;
  }

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestBadgePermission: false,
        defaultPresentBadge: false,
      ),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onNotificationTap?.call(response.payload);
      },
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(morningGlowChannel);
    await androidPlugin?.createNotificationChannel(incomingLumiChannel);
  }

  Future<void> showMorningGlow({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: 1,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_glow',
          'Morning glow deliveries',
          channelDescription: 'Batched Lumi deliveries sent after quiet hours.',
          importance: Importance.high,
          priority: Priority.high,
          number: 0,
        ),
        iOS: DarwinNotificationDetails(presentBadge: false, badgeNumber: 0),
      ),
    );
  }

  Future<void> showIncomingLumi({
    required LumiPushPayload payload,
    required int notificationId,
  }) async {
    final int? accentColor = payload.senderColorValue;
    await _plugin.show(
      id: notificationId,
      title: 'Lumi',
      body: payload.body,
      payload: jsonEncode(payload.toStorageMap()),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          incomingLumiChannel.id,
          incomingLumiChannel.name,
          channelDescription: incomingLumiChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          color: accentColor == null ? null : Color(accentColor),
          number: 0,
        ),
        iOS: const DarwinNotificationDetails(
          presentBadge: false,
          badgeNumber: 0,
        ),
      ),
    );
  }
}
