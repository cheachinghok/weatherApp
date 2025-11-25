import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

void main() {
  group('WeatherEntity', () {
    test('should be equal when properties are same', () {
      final weather1 = WeatherEntity(
        location: 'London',
        temperature: 15.0,
        condition: 'Sunny',
        humidity: 60,
        windSpeed: 5.0,
        date: DateTime(2023, 1, 1),
        iconUrl: 'icon.png',
      );

      final weather2 = WeatherEntity(
        location: 'London',
        temperature: 15.0,
        condition: 'Sunny',
        humidity: 60,
        windSpeed: 5.0,
        date: DateTime(2023, 1, 1),
        iconUrl: 'icon.png',
      );

      expect(weather1, weather2);
    });
  });
}