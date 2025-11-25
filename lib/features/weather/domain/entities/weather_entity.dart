import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String location;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final DateTime date;
  final String iconUrl;

  const WeatherEntity({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.date,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [
        location,
        temperature,
        condition,
        humidity,
        windSpeed,
        date,
        iconUrl,
      ];
}

class HourlyWeather extends Equatable {
  final DateTime time;
  final double temperature;
  final String condition;
  final String iconUrl;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [time, temperature, condition, iconUrl];
}

class DailyWeather extends Equatable {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;

  const DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [date, maxTemp, minTemp, condition, iconUrl];
}