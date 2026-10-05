import 'package:flutter/material.dart';
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