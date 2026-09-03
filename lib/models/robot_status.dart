import 'package:flutter/material.dart';
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