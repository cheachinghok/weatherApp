import 'package:http/http.dart' as http;
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

import '../../features/weather/data/repository/weather_repository_impl.dart';


class AppConfig {
  static WeatherRepository getWeatherRepository() {
      return WeatherRepositoryImpl(
        remoteDataSource: WeatherRemoteDataSourceImpl(client:  http.Client(),),
      );
  }
}