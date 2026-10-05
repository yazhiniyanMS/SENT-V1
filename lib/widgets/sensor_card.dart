import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.label,
    required this.value,
    this.unit = '',
    this.status = 'Normal',
    this.isDemo = false,
    this.statusColor,
  });

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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