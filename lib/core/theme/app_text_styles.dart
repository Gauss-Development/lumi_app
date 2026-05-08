import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

<<<<<<< HEAD
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
=======
  static const String fontFamily = 'Inter';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.32,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.28,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.14,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.9,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: display,
    headlineLarge: display,
    headlineMedium: headline,
    headlineSmall: headline,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    titleLarge: title,
    titleMedium: label,
    bodyLarge: body,
    bodyMedium: body,
<<<<<<< HEAD
    labelLarge: label,
=======
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    labelLarge: label,
    labelSmall: eyebrow,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  );
}
