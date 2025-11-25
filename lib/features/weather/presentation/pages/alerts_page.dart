import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alert_provider.dart';
import '../widgets/add_alert_dialog.dart';
import '../widgets/alert_card.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
      ),
      body: Consumer<AlertProvider>(
        builder: (context, alertProvider, child) {
          if (alertProvider.alerts.isEmpty) {
            return const Center(
              child: Text('No alerts set up'),
            );
          }

          return ListView.builder(
            itemCount: alertProvider.alerts.length,
            itemBuilder: (context, index) {
              final alert = alertProvider.alerts[index];
              return AlertCard(
                alert: alert,
                onToggle: () => alertProvider.toggleAlert(alert.id),
                onDelete: () => alertProvider.deleteAlert(alert.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddAlertDialog(),
          );
        },
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}