import 'package:dartz/dartz.dart';
import 'package:weather_app/features/alerts/domain/entities/alert_entity.dart';
import 'package:weather_app/features/alerts/domain/repositories/alert_repository.dart';

import '../../data/datasources/alert_local_data_source.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertLocalDataSource localDataSource;

  AlertRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, List<WeatherAlert>>> getAlerts() async {
    try {
      final alerts = await localDataSource.getAlerts();
      return Right(alerts);
    } catch (e) {
      return Left('Failed to get alerts: $e');
    }
  }

  @override
  Future<Either<String, void>> saveAlert(WeatherAlert alert) async {
    try {
      await localDataSource.saveAlert(alert);
      return const Right(null);
    } catch (e) {
      return Left('Failed to save alert: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteAlert(String alertId) async {
    try {
      await localDataSource.deleteAlert(alertId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete alert: $e');
    }
  }
}