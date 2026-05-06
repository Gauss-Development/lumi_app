class DateTimeUtils {
  const DateTimeUtils._();

  static bool isWithinQuietHours({
    required DateTime now,
    required int startHour,
    required int endHour,
  }) {
    if (startHour == endHour) {
      return false;
    }

    final currentHour = now.hour;
    if (startHour < endHour) {
      return currentHour >= startHour && currentHour < endHour;
    }

    return currentHour >= startHour || currentHour < endHour;
  }
}
