## PART 3 — CORE + MODELS

### lib/core/theme/app_theme.dart
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
  static const Color textSecondaryColor = Colors.grey[400]!;
  static const Color borderColor = Colors.grey[800]!;
  static const Color glowColor = Color.fromARGB(100, 255, 69, 0); // Glow for accents

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: infoColor,
      background: backgroundColor,
      surface: cardColor,
      error: dangerColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: textPrimaryColor,
    ),
    cardTheme: CardTheme(
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
      unselectedItemColor: Colors.grey[400],
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
        fontWeight: FontWeight.semiBold,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.semiBold,
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

### lib/models/sensor_data.dart
import 'package:sentinel_x/core/theme/app_theme.dart';

enum GasStatus { safe, warning, danger }

class SensorData {
  final double temperature;
  final double humidity;
  final double gasLevel;
  final GasStatus gasStatus;
  final bool waterDetected;
  final DateTime timestamp;
  final bool isDemo;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.gasLevel,
    required this.gasStatus,
    required this.waterDetected,
    required this.timestamp,
    required this.isDemo,
  });

  // Getter for gas status string
  String get gasStatusString {
    switch (gasStatus) {
      case GasStatus.safe:
        return 'SAFE';
      case GasStatus.warning:
        return 'WARNING';
      case GasStatus.danger:
        return 'DANGER';
      default:
        return 'UNKNOWN';
    }
  }

  // Getter for gas status color
  Color get gasStatusColor {
    switch (gasStatus) {
      case GasStatus.safe:
        return AppTheme.safeColor;
      case GasStatus.warning:
        return AppTheme.warningColor;
      case GasStatus.danger:
        return AppTheme.dangerColor;
      default:
        return AppTheme.infoColor;
    }
  }

  // Factory method for demo/mock data
  factory SensorData.demo() {
    return SensorData(
      temperature: 28.6,
      humidity: 64.0,
      gasLevel: 420.0,
      gasStatus: GasStatus.safe,
      waterDetected: false,
      timestamp: DateTime.now(),
      isDemo: true,
    );
  }

  // CopyWith method for updating values
  SensorData copyWith({
    double? temperature,
    double? humidity,
    double? gasLevel,
    GasStatus? gasStatus,
    bool? waterDetected,
    DateTime? timestamp,
    bool? isDemo,
  }) {
    return SensorData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      gasLevel: gasLevel ?? this.gasLevel,
      gasStatus: gasStatus ?? this.gasStatus,
      waterDetected: waterDetected ?? this.waterDetected,
      timestamp: timestamp ?? this.timestamp,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}

### lib/models/gps_data.dart
import 'package:sentinel_x/core/theme/app_theme.dart';

enum GpsStatus { acquired, searching, lost }

class GpsData {
  final double latitude;
  final double longitude;
  final double accuracy; // in meters
  final GpsStatus status;
  final DateTime timestamp;
  final bool isDemo;

  GpsData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.status,
    required this.timestamp,
    required this.isDemo,
  });

  // Getter for status string
  String get statusString {
    switch (status) {
      case GpsStatus.acquired:
        return 'ACQUIRED';
      case GpsStatus.searching:
        return 'SEARCHING';
      case GpsStatus.lost:
        return 'LOST';
      default:
        return 'UNKNOWN';
    }
  }

  // Getter for status color
  Color get statusColor {
    switch (status) {
      case GpsStatus.acquired:
        return AppTheme.safeColor;
      case GpsStatus.searching:
        return AppTheme.warningColor;
      case GpsStatus.lost:
        return AppTheme.dangerColor;
      default:
        return AppTheme.infoColor;
    }
  }

  // Factory method for demo/mock data
  factory GpsData.demo() {
    return GpsData(
      latitude: 13.0827,
      longitude: 80.2707,
      accuracy: 5.0,
      status: GpsStatus.acquired,
      timestamp: DateTime.now(),
      isDemo: true,
    );
  }

  // CopyWith method for updating values
  GpsData copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    GpsStatus? status,
    DateTime? timestamp,
    bool? isDemo,
  }) {
    return GpsData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}

### lib/models/robot_status.dart
import 'package:sentinel_x/core/theme/app_theme.dart';

class RobotStatus {
  final int battery; // percentage 0-100
  final String signal; // GOOD, FAIR, POOR, LOST
  final double speed; // m/s
  final String mode; // e.g., AUTONOMOUS, MANUAL, AUTO
  final DateTime timestamp;
  final bool isDemo;

  RobotStatus({
    required this.battery,
    required this.signal,
    required this.speed,
    required this.mode,
    required this.timestamp,
    required this.isDemo,
  });

  // Getter for battery color
  Color get batteryColor {
    if (battery > 50) return AppTheme.safeColor;
    if (battery > 20) return AppTheme.warningColor;
    return AppTheme.dangerColor;
  }

  // Getter for signal color
  Color get signalColor {
    switch (signal.toUpperCase()) {
      case 'GOOD':
        return AppTheme.safeColor;
      case 'FAIR':
        return AppTheme.warningColor;
      case 'POOR':
      case 'LOST':
        return AppTheme.dangerColor;
      default:
        return AppTheme.infoColor;
    }
  }

  // Factory method for demo/mock data
  factory RobotStatus.demo() {
    return RobotStatus(
      battery: 85,
      signal: 'GOOD',
      speed: 1.2,
      mode: 'AUTONOMOUS',
      timestamp: DateTime.now(),
      isDemo: true,
    );
  }

  // CopyWith method for updating values
  RobotStatus copyWith({
    int? battery,
    String? signal,
    double? speed,
    String? mode,
    DateTime? timestamp,
    bool? isDemo,
  }) {
    return RobotStatus(
      battery: battery ?? this.battery,
      signal: signal ?? this.signal,
      speed: speed ?? this.speed,
      mode: mode ?? this.mode,
      timestamp: timestamp ?? this.timestamp,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}

### lib/models/alert_event.dart
import 'package:sentinel_x/core/theme/app_theme.dart';

enum AlertSeverity { info, warning, danger }

class AlertEvent {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String source;
  final bool isDemo;

  AlertEvent({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.severity,
    required this.source,
    required this.isDemo,
  });

  // Getter for severity string
  String get severityString {
    switch (severity) {
      case AlertSeverity.info:
        return 'INFO';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.danger:
        return 'DANGER';
      default:
        return 'UNKNOWN';
    }
  }

  // Getter for severity color
  Color get severityColor {
    switch (severity) {
      case AlertSeverity.info:
        return AppTheme.infoColor;
      case AlertSeverity.warning:
        return AppTheme.warningColor;
      case AlertSeverity.danger:
        return AppTheme.dangerColor;
      default:
        return AppTheme.infoColor;
    }
  }

  // Factory method for demo/mock data
  factory AlertEvent.demo() {
    return AlertEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      title: 'Demo Event',
      description: 'This is a demo alert event',
      severity: AlertSeverity.info,
      source: 'Demo System',
      isDemo: true,
    );
  }
}