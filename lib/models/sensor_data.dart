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