import 'package:dartz/dartz.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<String, WeatherEntity>> getCurrentWeather(String location);
  Future<Either<String, List<HourlyWeather>>> getHourlyForecast(String location);
  Future<Either<String, List<DailyWeather>>> getDailyForecast(String location);
  Future<Either<String, String>> getCurrentLocation();
}