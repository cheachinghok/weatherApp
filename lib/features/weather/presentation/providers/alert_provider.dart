import 'package:flutter/material.dart';
import 'package:weather_app/features/alerts/domain/entities/alert_entity.dart';

import '../../../alerts/domain/repositories/alert_repository.dart';

class AlertProvider with ChangeNotifier {
  final AlertRepository alertRepository;

  AlertProvider({required this.alertRepository});

  List<WeatherAlert> _alerts = [];
  bool _isLoading = false;
  String _error = '';

  List<WeatherAlert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadAlerts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await alertRepository.getAlerts();
      result.fold(
        (failure) => _error = failure,
        (alerts) => _alerts = alerts,
      );
    } catch (e) {
      _error = 'Failed to load alerts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAlert({
    required String location,
    required AlertCondition condition,
    required double? threshold,
  }) async {
    final newAlert = WeatherAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      location: location,
      condition: condition,
      threshold: threshold,
      isActive: true,
      createdAt: DateTime.now(),
    );

    try {
      final result = await alertRepository.saveAlert(newAlert);
      result.fold(
        (failure) => _error = failure,
        (_) {
          _alerts.add(newAlert);
          _error = '';
        },
      );
    } catch (e) {
      _error = 'Failed to add alert: $e';
    }
    notifyListeners();
  }

  Future<void> toggleAlert(String alertId) async {
    final alertIndex = _alerts.indexWhere((alert) => alert.id == alertId);
    if (alertIndex != -1) {
      final updatedAlert = _alerts[alertIndex].copyWith(
        isActive: !_alerts[alertIndex].isActive,
      );

      try {
        final result = await alertRepository.saveAlert(updatedAlert);
        result.fold(
          (failure) => _error = failure,
          (_) {
            _alerts[alertIndex] = updatedAlert;
            _error = '';
          },
        );
      } catch (e) {
        _error = 'Failed to toggle alert: $e';
      }
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String alertId) async {
    try {
      final result = await alertRepository.deleteAlert(alertId);
      result.fold(
        (failure) => _error = failure,
        (_) {
          _alerts.removeWhere((alert) => alert.id == alertId);
          _error = '';
        },
      );
    } catch (e) {
      _error = 'Failed to delete alert: $e';
    }
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}