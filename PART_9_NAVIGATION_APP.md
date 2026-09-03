## PART 9 — NAVIGATION + APP

### lib/main.dart
import 'package:flutter/material.dart';
import 'package:sentinel_x/app.dart';

void main() {
  runApp(const SentinelXApp());
}

### lib/app.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_x/core/theme/app_theme.dart';
import 'package:sentinel_x/screens/navigation_screen.dart';

class SentinelXApp extends StatelessWidget {
  const SentinelXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'SENTINEL-X',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const NavigationScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  // Demo data fields
  double _temperature = 28.6;
  double _humidity = 64.0;
  double _gasLevel = 420.0;
  String _gasStatus = 'SAFE';
  bool _waterDetected = false;
  double _latitude = 13.0827;
  double _longitude = 80.2707;
  int _battery = 85;
  String _signal = 'GOOD';
  double _speed = 1.2;
  String _mode = 'AUTONOMOUS';
  bool _demoMode = true;
  bool _thermalSimulationEnabled = false;
  String _cameraSource = 'DEMO CAMERA';

  // Getters
  double get temperature => _temperature;
  double get humidity => _humidity;
  double get gasLevel => _gasLevel;
  String get gasStatus => _gasStatus;
  bool get waterDetected => _waterDetected;
  double get latitude => _latitude;
  double get longitude => _longitude;
  int get battery => _battery;
  String get signal => _signal;
  double get speed => _speed;
  String get mode => _mode;
  bool get demoMode => _demoMode;
  bool get thermalSimulationEnabled => _thermalSimulationEnabled;
  String get cameraSource => _cameraSource;

  // Setters for demo mode toggles
  void setDemoMode(bool value) {
    _demoMode = value;
    notifyListeners();
  }

  void setThermalSimulationEnabled(bool value) {
    _thermalSimulationEnabled = value;
    notifyListeners();
  }

  void setCameraSource(String source) {
    _cameraSource = source;
    notifyListeners();
  }

  AppState() {
    _startDemoDataUpdates();
  }

  void _startDemoDataUpdates() {
    // Update every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _temperature += (Random().nextDouble() - 0.5) * 0.5; // +/- 0.25
      _humidity += (Random().nextDouble() - 0.5) * 2; // +/- 1
      _gasLevel += (Random().nextDouble() - 0.5) * 10; // +/- 5
      // Clamp gas level to reasonable ranges for demo
      if (_gasLevel < 0) _gasLevel = 0;
      if (_gasLevel > 1000) _gasLevel = 1000;

      // Update gas status based on level
      if (_gasLevel < 300) {
        _gasStatus = 'SAFE';
      } else if (_gasLevel < 700) {
        _gasStatus = 'WARNING';
      } else {
        _gasStatus = 'DANGER';
      }

      // Occasionally change water detection (5% chance)
      if (Random().nextDouble() < 0.05) {
        _waterDetected = !_waterDetected;
      }

      // Occasionally change signal
      if (Random().nextDouble() < 0.1) {
        _signal = _signal == 'GOOD' ? 'FAIR' : 'GOOD';
      }

      // Occasionally change battery (slowly decrease)
      if (Random().nextDouble() < 0.02) {
        _battery = (_battery - 1).clamp(0, 100);
      }

      // Occasionally change speed
      _speed = (Random().nextDouble() * 0.5) + 1.0; // 1.0 to 1.5 m/s

      // Occasionally change mode
      if (Random().nextDouble() < 0.05) {
        _mode = [_mode, 'MANUAL', 'AUTO'][(Random().nextDouble() * 3).floor()];
      }

      // Update GPS slightly
      _latitude += (Random().nextDouble() - 0.5) * 0.0001;
      _longitude += (Random().nextDouble() - 0.5) * 0.0001;

      notifyListeners();
    });
  }
}

### lib/screens/navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider.Provider.dart';
import 'package:sentinel_x/app.dart';
import 'package:sentinel_x/screens/dashboard_screen.dart';
import 'package:sentinel_x/screens/sensors_screen.dart';
import 'package:sentinel_x/screens/alerts_screen.dart';
import 'package:sentinel_x/screens/map_screen.dart';
import 'package:sentinel_x/screens/settings_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SensorsScreen(),
    AlertsScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors_outlined),
            label: 'Sensors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}