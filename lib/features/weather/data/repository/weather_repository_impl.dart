import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, WeatherEntity>> getCurrentWeather(String location) async {
    try {
      final data = await remoteDataSource.getCurrentWeather(location);
      final weather = WeatherEntity(
        location: data['location']['name'],
        temperature: data['current']['temp_c'].toDouble(),
        condition: data['current']['condition']['text'],
        humidity: data['current']['humidity'],
        windSpeed: data['current']['wind_kph'].toDouble(),
        date: DateTime.parse(data['location']['localtime']),
        iconUrl: 'https:${data['current']['condition']['icon']}',
      );
      return Right(weather);
    } catch (e) {
      return Left('Failed to get current weather: $e');
    }
  }

  @override
  Future<Either<String, List<DailyWeather>>> getDailyForecast(String location) async {
    try {
      final data = await remoteDataSource.getDailyForecast(location);
      final dailyForecast = data.map<DailyWeather>((day) {
        return DailyWeather(
          date: DateTime.parse(day['date']),
          maxTemp: day['day']['maxtemp_c'].toDouble(),
          minTemp: day['day']['mintemp_c'].toDouble(),
          condition: day['day']['condition']['text'],
          iconUrl: 'https:${day['day']['condition']['icon']}',
        );
      }).toList();
      return Right(dailyForecast);
    } catch (e) {
      return Left('Failed to get daily forecast: $e');
    }
  }

  @override
  Future<Either<String, List<HourlyWeather>>> getHourlyForecast(String location) async {
    try {
      final data = await remoteDataSource.getHourlyForecast(location);
      final hourlyForecast = data.map<HourlyWeather>((hour) {
        return HourlyWeather(
          time: DateTime.parse(hour['time']),
          temperature: hour['temp_c'].toDouble(),
          condition: hour['condition']['text'],
          iconUrl: 'https:${hour['condition']['icon']}',
        );
      }).toList();
      return Right(hourlyForecast);
    } catch (e) {
      return Left('Failed to get hourly forecast: $e');
    }
  }

  @override
  Future<Either<String, String>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left('Location services are disabled. Please enable location services.');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          return const Left('Location permissions are denied. Please enable location permissions in app settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left('Location permissions are permanently denied. Please enable them in app settings.');
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        
        // Get current position with timeout
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ).timeout(const Duration(seconds: 10));

        // Return city name instead of coordinates for better API results
        return Right('${position.latitude},${position.longitude}');
        
      } else {
        return const Left('Location permission not granted.');
      }
    } catch (e) {
      return Left('Failed to get location: ${e.toString()}');
    }
  }
}