import 'package:postgrest/postgrest.dart';

bool isNotFoundError(Object error) {
  if (error is PostgrestException) {
    return error.code == 'PGRST116';
  }
  return false;
}

String postgrestMessage(Object error, String fallback) {
  if (error is PostgrestException) {
    return error.message.isNotEmpty ? error.message : fallback;
  }
  return fallback;
}
