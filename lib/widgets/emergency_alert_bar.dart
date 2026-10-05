import 'package:flutter/material.dart';

class EmergencyAlertBar extends StatelessWidget {
  final VoidCallback onSosPressed;

  const EmergencyAlertBar({
    super.key,
    required this.onSosPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '⚠ EMERGENCY ALERT\nSOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onSosPressed,
            icon: const Icon(Icons.send, size: 20),
            label: const Text('SOS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}