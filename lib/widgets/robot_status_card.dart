import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class RobotStatusCard extends StatelessWidget {
  const RobotStatusCard({
    super.key,
    required this.battery,
    required this.signal,
    required this.speed,
    required this.mode,
    this.isDemo = false,
  });

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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