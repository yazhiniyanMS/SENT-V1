## PART 8 — SCREENS

### lib/screens/dashboard_screen.dart
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
  const DashboardScreen({Key? key}) : super(key: key);

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
            const EmergencyAlertBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          mainAxisAlignment: MainAxisSpaceBetween,
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
                    ? AppTheme.warningColor.withOpacity(0.2)
                    : AppTheme.safeColor.withOpacity(0.2),
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
                color: AppTheme.dangerColor.withOpacity(0.2),
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

### lib/screens/sensors_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/widgets/sensor_card.dart';
import 'package:sentinel_x/widgets/gps_card.dart';
import 'package:sentinel_x/models/sensor_data.dart';
import 'package:sentinel_x/models/gps_data.dart';
import 'package:sentinel_x/models/robot_status.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({Key? key}) : super(key: key);

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

### lib/screens/alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/models/alert_event.dart';
import 'package:sentinel_x/services/alert_service.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertService = Provider.of<AlertService>(context);
    final alerts = alertService.alerts;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ALERTS & EVENTS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // For demo, we can add a dummy alert
              alertService.addAlert(
                title: 'Demo Alert',
                description: 'This is a demo alert added via refresh',
                severity: AlertSeverity.info,
                source: 'Demo System',
                isDemo: true,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: alerts.isEmpty
            ? const Center(
                child: Text(
                  'No alerts',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return _buildAlertItem(alert);
                },
              ),
      ),
    );
  }

  Widget _buildAlertItem(AlertEvent alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: alert.severityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')}:${alert.timestamp.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                      Icon(
                        _getAlertIcon(alert.severity),
                        color: alert.severityColor,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  if (alert.isDemo)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'DEMO EVENT',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAlertIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.info:
        return Icons.info_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber_outlined;
      case AlertSeverity.danger:
        return Icons.error_outline;
      default:
        return Icons.notifications_outlined;
    }
  }
}

### lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/models/gps_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ROBOT TRACKING'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(appState.latitude, appState.longitude),
                    zoom: 15,
                    interactiveFlags: appState.demoMode
                        ? InteractiveFlag.all
                        : InteractiveFlag.none,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(appState.latitude, appState.longitude),
                          builder: (ctx) => const Icon(
                            Icons.location_on,
                            color: AppTheme.infoColor,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Tracking info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRACKING INFO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTrackingItem('LATITUDE',
                          '${appState.latitude.toStringAsFixed(6)}°'),
                      _buildTrackingItem('LONGITUDE',
                          '${appState.longitude.toStringAsFixed(6)}°'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTrackingItem('ALTITUDE', '120m'), // Placeholder
                      _buildTrackingItem('SPEED',
                          '${appState.speed.toStringAsFixed(1)} m/s'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTrackingItem('HEADING', 'NE'), // Placeholder
                      _buildTrackingItem('SATELLITES', '8'), // Placeholder
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (appState.demoMode)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'DEMO LOCATION',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

### lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('SYSTEM'),
            _buildSwitchTile(
              'Demo Mode',
              appState.demoMode,
              (value) => appState.setDemoMode(value),
              icon: Icons.demo,
            ),
            _buildSwitchTile(
              'Thermal Simulation',
              appState.thermalSimulationEnabled,
              (value) => appState.setThermalSimulationEnabled(value),
              icon: Icons.ac_unit,
            ),
            _buildSettingsTile(
              Icons.videocam,
              'Camera Source',
              appState.cameraSource,
              Icons.chevron_right,
              onTap: () {
                // TODO: Implement camera source selection
              },
            ),
            _buildSettingsTile(
              Icons.bluetooth,
              'Sensor Connection',
              'NOT CONNECTED',
              Icons.chevron_right,
            ),
            _buildSettingsTile(
              Icons.wifi,
              'LoRa Connection',
              'NOT CONNECTED',
              Icons.chevron_right,
            ),
            const Divider(
              color: Colors.white24,
              height: 32,
            ),
            _buildSectionHeader('DISPLAY'),
            _buildSettingsTile(
              Icons.brightness_6,
              'Theme',
              'Dark',
              Icons.chevron_right,
            ),
            _buildSettingsTile(
              Icons.remove_red_eye,
              'Video Quality',
              'Medium',
              Icons.chevron_right,
            ),
            _buildSettingsTile(
              Icons.animation,
              'Animations',
              'Enabled',
              Icons.chevron_right,
            ),
            const Divider(
              color: Colors.white24,
              height: 32,
            ),
            _buildSectionHeader('ABOUT'),
            _buildSettingsTile(
              Icons.info,
              'About Sentinel-X',
              'Version 1.0.0',
              Icons.chevron_right,
            ),
            _buildSettingsTile(
              Icons.developer_mode,
              'Developer Options',
              '',
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.infoColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged,
      {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: AppTheme.infoColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      IconData icon, String title, String subtitle, IconData trailing,
      {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: AppTheme.infoColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
        trailing: Icon(trailing, color: Colors.white60),
        onTap: onTap,
      ),
    );
  }
}