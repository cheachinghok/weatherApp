import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/features/alerts/domain/entities/alert_entity.dart';

import '../providers/alert_provider.dart';

class AddAlertDialog extends StatefulWidget {
  const AddAlertDialog({super.key});

  @override
  State<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  AlertCondition _selectedCondition = AlertCondition.rain;
  final _thresholdController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Weather Alert'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter city name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AlertCondition>(
              value: _selectedCondition,
              onChanged: (value) {
                setState(() {
                  _selectedCondition = value!;
                });
              },
              items: AlertCondition.values.map((condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(_getConditionText(condition)),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Alert Condition',
              ),
            ),
            if (_selectedCondition == AlertCondition.temperatureAbove ||
                _selectedCondition == AlertCondition.temperatureBelow)
              TextFormField(
                controller: _thresholdController,
                decoration: const InputDecoration(
                  labelText: 'Temperature (°C)',
                  hintText: 'Enter temperature',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter temperature';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addAlert,
          child: const Text('Add Alert'),
        ),
      ],
    );
  }

  String _getConditionText(AlertCondition condition) {
    switch (condition) {
      case AlertCondition.temperatureAbove:
        return 'Temperature Above';
      case AlertCondition.temperatureBelow:
        return 'Temperature Below';
      case AlertCondition.rain:
        return 'Rain';
      case AlertCondition.snow:
        return 'Snow';
      case AlertCondition.wind:
        return 'High Wind';
    }
  }

  void _addAlert() {
    if (_formKey.currentState!.validate()) {
      final alertProvider = context.read<AlertProvider>();
      
      alertProvider.addAlert(
        location: _locationController.text,
        condition: _selectedCondition,
        threshold: (_selectedCondition == AlertCondition.temperatureAbove ||
                _selectedCondition == AlertCondition.temperatureBelow)
            ? double.parse(_thresholdController.text)
            : null,
      );

      Navigator.of(context).pop();
    }
  }
}