import 'package:flutter/material.dart';

import 'package:lumi/app.dart';
import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/flavor.dart';
import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/services/push_notification_service.dart';

Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = await EnvironmentConfig.load(flavor: flavor);

  await configureDependencies(environment);
  await sl<PushNotificationService>().initialize();

  runApp(const LumiApp());
}
