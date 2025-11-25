import 'package:dartz/dartz.dart';
import '../entities/alert_entity.dart';

abstract class AlertRepository {
  Future<Either<String, List<WeatherAlert>>> getAlerts();
  Future<Either<String, void>> saveAlert(WeatherAlert alert);
  Future<Either<String, void>> deleteAlert(String alertId);
}