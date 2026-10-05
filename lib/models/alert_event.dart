import 'package:flutter/material.dart';
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