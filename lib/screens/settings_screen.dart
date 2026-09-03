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