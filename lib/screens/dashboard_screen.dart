import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/widgets/live_camera_card.dart';
import 'package:sentinel_x/widgets/sensor_card.dart';
import 'package:sentinel_x/widgets/gps_card.dart';
import 'package:sentinel_x/widgets/robot_status_card.dart';
import 'package:sentinel_x/widgets/emergency_alert_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(appState),
            const SizedBox(height: 16),
            // Live Camera
            const LiveCameraCard(),
            const SizedBox(height: 16),
            // Sensor Row (Temperature, Humidity, Gas, Water)
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    label: 'TEMPERATURE',
                    value: appState.temperature.toStringAsFixed(1),
                    unit: '°C',
                    status: 'Environment Normal',
                    isDemo: appState.demoMode,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    label: 'HUMIDITY',
                    value: appState.humidity.toStringAsFixed(0),
                    unit: '%',
                    status: 'Normal',
                    isDemo: appState.demoMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Gas and Water Detection Row
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    label: 'GAS DETECTION',
                    value: appState.gasLevel.toStringAsFixed(0),
                    status: appState.gasStatus,
                    isDemo: appState.demoMode,
                    statusColor: (_getGasStatusColor(appState.gasStatus)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    label: 'WATER DETECTION',
                    value: appState.waterDetected ? 'DETECTED' : 'SAFE',
                    status: appState.waterDetected ? 'DETECTED' : 'SAFE',
                    isDemo: appState.demoMode,
                    statusColor: appState.waterDetected
                        ? AppTheme.dangerColor
                        : AppTheme.safeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // GPS and Robot Status Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GpsCard(
                    latitude: appState.latitude,
                    longitude: appState.longitude,
                    status: 'ACQUIRED',
                    isDemo: appState.demoMode,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: RobotStatusCard(
                    battery: appState.battery,
                    signal: appState.signal,
                    speed: appState.speed,
                    mode: appState.mode,
                    isDemo: appState.demoMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Emergency Alert Bar
            EmergencyAlertBar(
              onSosPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SOS ALERT TRIGGERED')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppState appState) {
    return Column(
      children: [
        const Text(
          'SENTINEL-X',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'AI-POWERED DISASTER RESPONSE SYSTEM',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.infoColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu icon (we'll use a placeholder for now)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // TODO: Open menu/drawer
              },
              color: AppTheme.infoColor,
            ),
            // Connection indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: appState.demoMode
                    ? AppTheme.warningColor.withValues(alpha: 0.2)
                    : AppTheme.safeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: appState.demoMode
                      ? AppTheme.warningColor
                      : AppTheme.safeColor,
                  width: 1,
                ),
              ),
              child: Text(
                appState.demoMode ? 'DEMO MODE' : 'LIVE SYSTEM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: appState.demoMode
                      ? AppTheme.warningColor
                      : AppTheme.safeColor,
                ),
              ),
            ),
            // LIVE indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.dangerColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.dangerColor,
                  width: 1,
                ),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.dangerColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getGasStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SAFE':
        return AppTheme.safeColor;
      case 'WARNING':
        return AppTheme.warningColor;
      case 'DANGER':
        return AppTheme.dangerColor;
      default:
        return AppTheme.infoColor;
    }
  }
}