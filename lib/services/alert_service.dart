import 'package:flutter/foundation.dart';
import 'package:sentinel_x/models/alert_event.dart';

class AlertService extends ChangeNotifier {
  // In a real app, this would be a list or a stream from a backend
  final List<AlertEvent> _alerts = [];

  // Add an alert
  void addAlert({
    required String title,
    required String description,
    required AlertSeverity severity,
    required String source,
    required bool isDemo,
  }) {
    final alert = AlertEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      title: title,
      description: description,
      severity: severity,
      source: source,
      isDemo: isDemo,
    );
    _alerts.add(alert);
    notifyListeners();
  }

  // Get all alerts
  List<AlertEvent> get alerts => List.unmodifiable(_alerts);

  // Clear alerts (for demo purposes)
  void clear() {
    _alerts.clear();
    notifyListeners();
  }
}