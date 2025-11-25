import 'package:equatable/equatable.dart';

enum AlertCondition {
  temperatureAbove,
  temperatureBelow,
  rain,
  snow,
  wind,
}

class WeatherAlert extends Equatable {
  final String id;
  final String location;
  final AlertCondition condition;
  final double? threshold;
  final bool isActive;
  final DateTime createdAt;

  const WeatherAlert({
    required this.id,
    required this.location,
    required this.condition,
    this.threshold,
    required this.isActive,
    required this.createdAt,
  });

  WeatherAlert copyWith({
    String? id,
    String? location,
    AlertCondition? condition,
    double? threshold,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return WeatherAlert(
      id: id ?? this.id,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      threshold: threshold ?? this.threshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get conditionText {
    switch (condition) {
      case AlertCondition.temperatureAbove:
        return 'Temperature above ${threshold?.toStringAsFixed(1)}°C';
      case AlertCondition.temperatureBelow:
        return 'Temperature below ${threshold?.toStringAsFixed(1)}°C';
      case AlertCondition.rain:
        return 'Rain expected';
      case AlertCondition.snow:
        return 'Snow expected';
      case AlertCondition.wind:
        return 'High wind speed';
    }
  }

  @override
  List<Object?> get props => [id, location, condition, threshold, isActive, createdAt];
}