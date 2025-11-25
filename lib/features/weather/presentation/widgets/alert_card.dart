import 'package:flutter/material.dart';
import 'package:weather_app/features/alerts/domain/entities/alert_entity.dart';

class AlertCard extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          alert.isActive ? Icons.notifications_active : Icons.notifications_off,
          color: alert.isActive ? Colors.green : Colors.grey,
        ),
        title: Text(alert.location),
        subtitle: Text(alert.conditionText),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                alert.isActive ? Icons.toggle_on : Icons.toggle_off,
                color: alert.isActive ? Colors.blue : Colors.grey,
              ),
              onPressed: onToggle,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}