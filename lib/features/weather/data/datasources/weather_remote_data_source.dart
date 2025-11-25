
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> getCurrentWeather(String location);
  Future<List<dynamic>> getHourlyForecast(String location);
  Future<List<dynamic>> getDailyForecast(String location);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {

  WeatherRemoteDataSourceImpl({required http.Client client});

  @override
  Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    // Use mock data for now - replace with real API call when you have a key
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      "location": {
        "name": location,
        "region": "Mock Region", 
        "country": "Mock Country",
        "localtime": DateTime.now().toIso8601String(),
      },
      "current": {
        "temp_c": 22.5,
        "condition": {
          "text": "Sunny",
          "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
        },
        "humidity": 65,
        "wind_kph": 15.0,
      }
    };
  }

  @override
  Future<List<dynamic>> getHourlyForecast(String location) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    return List.generate(24, (index) {
      final hour = DateTime(now.year, now.month, now.day, index);
      return {
        "time": hour.toIso8601String(),
        "temp_c": 20.0 + (index % 5),
        "condition": {
          "text": index < 6 || index > 18 ? "Clear" : "Partly Cloudy",
          "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
        }
      };
    });
  }

  @override
  Future<List<dynamic>> getDailyForecast(String location) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    return List.generate(14, (index) {
      final date = now.add(Duration(days: index));
      return {
        "date": date.toIso8601String().split('T')[0],
        "day": {
          "maxtemp_c": 25.0 + (index % 3),
          "mintemp_c": 15.0 + (index % 2),
          "condition": {
            "text": ["Sunny", "Cloudy", "Rainy"][index % 3],
            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
          }
        }
      };
    });
  }
}