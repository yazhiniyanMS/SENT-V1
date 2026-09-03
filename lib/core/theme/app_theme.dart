import 'package:flutter/material.dart';

class AppTheme {
  // Dark theme colors for disaster response UI
  static const Color backgroundColor = Color(0xFF000000); // Pure black
  static const Color cardColor = Color(0xFF121212); // Slightly lighter black for cards
  static const Color accentColor = Color(0xFFFF4500); // OrangeRed for emergencies
  static const Color safeColor = Color(0xFF00FF00); // Green for safe
  static const Color warningColor = Color(0xFFFFA500); // Orange for warning
  static const Color dangerColor = Color(0xFFFF0000); // Red for danger
  static const Color infoColor = Color(0xFF00BFFF); // DeepSkyBlue for information
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFBDBDBD); // grey[400]
  static const Color borderColor = Color(0xFF424242); // grey[800]
  static const Color glowColor = Color.fromARGB(100, 255, 69, 0); // Glow for accents

  // Thermal simulation gradient colors
  static const Color thermalCold = Color(0xFF00008B); // Dark Blue
  static const Color thermalCool = Color(0xFF0000FF); // Blue
  static const Color thermalMedium = Color(0xFF00FF00); // Green
  static const Color thermalWarm = Color(0xFFFFFF00); // Yellow
  static const Color thermalHot = Color(0xFFFFA500); // Orange
  static const Color thermalHottest = Color(0xFFFFFFFF); // White

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: infoColor,
      surface: cardColor,
      error: dangerColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: textPrimaryColor,
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black87,
      selectedItemColor: accentColor,
      unselectedItemColor: textSecondaryColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textSecondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
    ),
  );
}