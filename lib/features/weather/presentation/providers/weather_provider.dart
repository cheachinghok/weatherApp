import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherProvider({required this.weatherRepository});

  WeatherEntity? _currentWeather;
  List<HourlyWeather> _hourlyForecast = [];
  List<DailyWeather> _dailyForecast = [];
  bool _isLoading = false;
  String _error = '';
  String _currentLocation = '';

  WeatherEntity? get currentWeather => _currentWeather;
  List<HourlyWeather> get hourlyForecast => _hourlyForecast;
  List<DailyWeather> get dailyForecast => _dailyForecast;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentLocation => _currentLocation;

  Future<void> getCurrentLocationWeather() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final locationResult = await weatherRepository.getCurrentLocation();
      
      locationResult.fold(
        (failure) {
          _error = failure;
          // Fallback to default location if current location fails
          _getDefaultLocationWeather();
        },
        (location) async {
          await getWeatherByLocation(location);
        },
      );
    } catch (e) {
      _error = 'Unexpected error: $e';
      _getDefaultLocationWeather();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getDefaultLocationWeather() async {
    // Use a default location if current location fails
    const defaultLocations = ['London', 'New York', 'Tokyo', 'Paris'];
    
    for (final location in defaultLocations) {
      try {
        await getWeatherByLocation(location);
        if (_error.isEmpty) break; // Success, stop trying
      } catch (e) {
        continue; // Try next location
      }
    }
    
    if (_error.isNotEmpty && _currentWeather == null) {
      _error = 'Failed to load weather data. Please check your connection and try again.';
    }
  }

  Future<void> getWeatherByLocation(String location) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final currentResult = await weatherRepository.getCurrentWeather(location);
      final hourlyResult = await weatherRepository.getHourlyForecast(location);
      final dailyResult = await weatherRepository.getDailyForecast(location);

      // Handle current weather result
      currentResult.fold(
        (failure) => _error = failure,
        (weather) => _currentWeather = weather,
      );

      // Handle hourly forecast
      hourlyResult.fold(
        (failure) {
          if (_error.isEmpty) _error = failure;
        },
        (hourly) => _hourlyForecast = hourly,
      );

      // Handle daily forecast
      dailyResult.fold(
        (failure) {
          if (_error.isEmpty) _error = failure;
        },
        (daily) => _dailyForecast = daily,
      );

      if (_currentWeather != null) {
        _currentLocation = location;
        _error = ''; // Clear error if we successfully got data
      }
    } catch (e) {
      _error = 'Failed to load weather data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void setMockDataForTesting() {
    _currentWeather = WeatherEntity(
      location: 'London',
      temperature: 22.5,
      condition: 'Sunny',
      humidity: 65,
      windSpeed: 15.0,
      date: DateTime.now(),
      iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
    );
    
    _hourlyForecast = List.generate(24, (index) {
      final time = DateTime.now().add(Duration(hours: index));
      return HourlyWeather(
        time: time,
        temperature: 20.0 + (index % 5),
        condition: index < 6 || index > 18 ? 'Clear' : 'Partly Cloudy',
        iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
      );
    });
    
    _dailyForecast = List.generate(14, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DailyWeather(
        date: date,
        maxTemp: 25.0 + (index % 3),
        minTemp: 15.0 + (index % 2),
        condition: ['Sunny', 'Cloudy', 'Rainy'][index % 3],
        iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
      );
    });
    
    _currentLocation = 'London';
    _error = '';
    notifyListeners();
  }
}