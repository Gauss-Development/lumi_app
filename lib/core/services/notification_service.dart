import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationChannel morningGlowChannel =
      AndroidNotificationChannel(
        'morning_glow',
        'Morning glow deliveries',
        description: 'Batched Lumi deliveries sent after quiet hours.',
        importance: Importance.high,
      );

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (_) {},
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(morningGlowChannel);
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
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
