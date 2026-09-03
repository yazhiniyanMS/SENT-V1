import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/widgets/sensor_card.dart';
import 'package:sentinel_x/widgets/gps_card.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

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
            _buildHeader(),
            const SizedBox(height: 24),
            // Temperature Card
            SensorCard(
              label: 'TEMPERATURE',
              value: appState.temperature.toStringAsFixed(1),
              unit: '°C',
              status: 'Environment Normal',
              isDemo: appState.demoMode,
            ),
            const SizedBox(height: 16),
            // Humidity Card
            SensorCard(
              label: 'HUMIDITY',
              value: appState.humidity.toStringAsFixed(0),
              unit: '%',
              status: 'Normal',
              isDemo: appState.demoMode,
            ),
            const SizedBox(height: 16),
            // Gas Card
            SensorCard(
              label: 'GAS DETECTION',
              value: appState.gasLevel.toStringAsFixed(0),
              status: appState.gasStatus,
              isDemo: appState.demoMode,
              statusColor: (_getGasStatusColor(appState.gasStatus)),
            ),
            const SizedBox(height: 16),
            // Water Detection Card
            SensorCard(
              label: 'WATER DETECTION',
              value: appState.waterDetected ? 'DETECTED' : 'SAFE',
              status: appState.waterDetected ? 'DETECTED' : 'SAFE',
              isDemo: appState.demoMode,
              statusColor: appState.waterDetected
                  ? AppTheme.dangerColor
                  : AppTheme.safeColor,
            ),
            const SizedBox(height: 16),
            // GPS Card
            GpsCard(
              latitude: appState.latitude,
              longitude: appState.longitude,
              status: 'ACQUIRED',
              isDemo: appState.demoMode,
            ),
            const SizedBox(height: 16),
            // Battery Card
            SensorCard(
              label: 'BATTERY',
              value: appState.battery.toStringAsFixed(0),
              unit: '%',
              status: appState.battery > 50
                  ? 'Good'
                  : appState.battery > 20
                      ? 'Fair'
                      : 'Low',
              isDemo: appState.demoMode,
              statusColor: appState.battery > 50
                  ? AppTheme.safeColor
                  : appState.battery > 20
                      ? AppTheme.warningColor
                      : AppTheme.dangerColor,
            ),
            const SizedBox(height: 16),
            // Signal Strength Card
            SensorCard(
              label: 'SIGNAL STRENGTH',
              value: appState.signal,
              status: appState.signal == 'GOOD'
                  ? 'Good'
                  : appState.signal == 'FAIR'
                      ? 'Fair'
                      : 'Poor',
              isDemo: appState.demoMode,
              statusColor: appState.signal == 'GOOD'
                  ? AppTheme.safeColor
                  : appState.signal == 'FAIR'
                      ? AppTheme.warningColor
                      : AppTheme.dangerColor,
            ),
            const SizedBox(height: 16),
            // Speed Card
            SensorCard(
              label: 'SPEED',
              value: '${appState.speed.toStringAsFixed(1)} m/s',
              status: 'Normal',
              isDemo: appState.demoMode,
            ),
            const SizedBox(height: 16),
            // Mode Card
            SensorCard(
              label: 'MODE',
              value: appState.mode,
              status: 'Normal',
              isDemo: appState.demoMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'SENSORS',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
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