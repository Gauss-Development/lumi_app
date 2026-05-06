import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const display = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.8,
  );

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodyMedium = body;

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: display,
    headlineLarge: display,
    headlineMedium: title,
    headlineSmall: title,
    titleLarge: title,
    titleMedium: label,
    bodyLarge: body,
    bodyMedium: body,
    labelLarge: label,
  );
}
