import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  const PermissionUtils._();

  static Future<PermissionStatus> requestNotifications() async {
    return Permission.notification.request();
  }

  static Future<PermissionStatus> requestContacts() async {
    return Permission.contacts.request();
  }
}
