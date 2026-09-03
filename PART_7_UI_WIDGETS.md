## PART 7 — UI WIDGETS

### lib/widgets/sensor_card.dart
import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    Key? key,
    required this.label,
    required this.value,
    this.unit = '',
    this.status = 'Normal',
    this.isDemo = false,
    this.statusColor,
  }) : super(key: key);

  final String label;
  final String value;
  final String unit;
  final String status;
  final bool isDemo;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final Color effectiveStatusColor = statusColor ??
        (status.toLowerCase() == 'safe'
            ? AppTheme.safeColor
            : status.toLowerCase() == 'warning'
                ? AppTheme.warningColor
                : status.toLowerCase() == 'danger'
                    ? AppTheme.dangerColor
                    : AppTheme.infoColor);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisSpaceBetween,
              children: [
                Text(
                  '$value$unit',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isDemo)
                  const Text(
                    'DEMO DATA',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: effectiveStatusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

### lib/widgets/gps_card.dart
import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class GpsCard extends StatelessWidget {
  const GpsCard({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.isDemo = false,
  }) : super(key: key);

  final double latitude;
  final double longitude;
  final String status;
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        status.toLowerCase() == 'acquired' ? AppTheme.safeColor : AppTheme.warningColor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GPS TRACKING',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Latitude: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  latitude.toStringAsFixed(6),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Longitude: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  longitude.toStringAsFixed(6),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (isDemo)
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
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

### lib/widgets/robot_status_card.dart
import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class RobotStatusCard extends StatelessWidget {
  const RobotStatusCard({
    Key? key,
    required this.battery,
    required this.signal,
    required this.speed,
    required this.mode,
    this.isDemo = false,
  }) : super(key: key);

  final int battery;
  final String signal;
  final double speed;
  final String mode;
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    final Color batteryColor =
        battery > 50 ? AppTheme.safeColor : battery > 20 ? AppTheme.warningColor : AppTheme.dangerColor;
    final Color signalColor =
        signal == 'GOOD' ? AppTheme.safeColor : signal == 'FAIR' ? AppTheme.warningColor : AppTheme.dangerColor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ROBOT STATUS',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusRow('BATTERY', '$battery%', batteryColor),
            const SizedBox(height: 4),
            _buildStatusRow('SIGNAL', signal, signalColor),
            const SizedBox(height: 4),
            _buildStatusRow('SPEED', '${speed.toStringAsFixed(1)} m/s', AppTheme.infoColor),
            const SizedBox(height: 4),
            _buildStatusRow('MODE', mode, AppTheme.infoColor),
            if (isDemo)
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'DEMO TELEMETRY',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisSpaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

### lib/widgets/emergency_alert_bar.dart
import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/services/alert_service.dart';

class EmergencyAlertBar extends StatelessWidget {
  const EmergencyAlertBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => _showConfirmDialog(context),
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text('⚠ SOS'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.dangerColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Send emergency alert?',
          style: TextStyle(color: AppTheme.textPrimaryColor),
        ),
        content: const Text(
          'This will send an emergency signal to the monitoring system.',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendAlert(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('SEND ALERT'),
          ),
        ],
      ),
    );
  }

  void _sendAlert(BuildContext context) {
    // Use the alert service to send an alert
    final alertService = AlertService();
    alertService.addAlert(
      title: 'Emergency SOS',
      description: 'Manual emergency trigger activated',
      severity: AlertSeverity.danger,
      source: 'User',
      isDemo: true,
    );
    // Show a snackbar or toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency alert sent.'),
        backgroundColor: AppTheme.dangerColor,
      ),
    );
  }
}