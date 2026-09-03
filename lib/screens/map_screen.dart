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