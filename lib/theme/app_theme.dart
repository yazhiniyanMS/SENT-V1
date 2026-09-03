import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF000000); // Black
  static const Color secondaryColor = Color(0xFF1A1A1A); // Dark gray
  static const Color accentColor = Color(0xFFFF4500); // Orange-Red
  static const Color safeColor = Color(0xFF00FF00); // Green
  static const Color warningColor = Color(0xFFFFD700); // Gold/Yellow
  static const Color dangerColor = Color(0xFFFF0000); // Red
  static const Color infoColor = Color(0xFF00BFFF); // Deep Sky Blue
  static const Color thermalCold = Color(0xFF00008B); // Dark Blue
  static const Color thermalCool = Color(0xFF0000FF); // Blue
  static const Color thermalMedium = Color(0xFF00FF00); // Green
  static const Color thermalWarm = Color(0xFFFFFF00); // Yellow
  static const Color thermalHot = Color(0xFFFFA500); // Orange
  static const Color thermalHottest = Color(0xFFFFFFFF); // White

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}