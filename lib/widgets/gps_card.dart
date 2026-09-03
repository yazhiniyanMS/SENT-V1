import 'package:flutter/material.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';

class GpsCard extends StatelessWidget {
  const GpsCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.isDemo = false,
  });

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