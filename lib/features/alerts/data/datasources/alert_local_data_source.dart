import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/alerts/domain/entities/alert_entity.dart';

abstract class AlertLocalDataSource {
  Future<List<WeatherAlert>> getAlerts();
  Future<void> saveAlert(WeatherAlert alert);
  Future<void> deleteAlert(String alertId);
}

class AlertLocalDataSourceImpl implements AlertLocalDataSource {
  static const String _alertsKey = 'weather_alerts';

  @override
  Future<List<WeatherAlert>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getStringList(_alertsKey) ?? [];

    return alertsJson.map((json) {
      final map = json.split('|');
      return WeatherAlert(
        id: map[0],
        location: map[1],
        condition: AlertCondition.values[int.parse(map[2])],
        threshold: map[3].isNotEmpty ? double.parse(map[3]) : null,
        isActive: map[4] == 'true',
        createdAt: DateTime.parse(map[5]),
      );
    }).toList();
  }

  @override
  Future<void> saveAlert(WeatherAlert alert) async {
    final prefs = await SharedPreferences.getInstance();
    final alerts = await getAlerts();
    
    // Remove existing alert with same id
    alerts.removeWhere((a) => a.id == alert.id);
    alerts.add(alert);

    final alertsJson = alerts.map((alert) {
      return '${alert.id}|${alert.location}|${alert.condition.index}|${alert.threshold ?? ''}|${alert.isActive}|${alert.createdAt.toIso8601String()}';
    }).toList();

    await prefs.setStringList(_alertsKey, alertsJson);
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final alerts = await getAlerts();
    alerts.removeWhere((alert) => alert.id == alertId);

    final alertsJson = alerts.map((alert) {
      return '${alert.id}|${alert.location}|${alert.condition.index}|${alert.threshold ?? ''}|${alert.isActive}|${alert.createdAt.toIso8601String()}';
    }).toList();

    await prefs.setStringList(_alertsKey, alertsJson);
  }
}