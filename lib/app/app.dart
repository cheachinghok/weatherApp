import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/core/themes/app_theme.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/alerts/data/datasources/alert_local_data_source.dart';
import 'package:weather_app/features/weather/presentation/pages/weather_home_page.dart';

import '../features/alerts/domain/repositories/alert_repository_impl.dart';
import '../features/weather/data/repository/weather_repository_impl.dart';
import '../features/weather/presentation/providers/alert_provider.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherRepository: WeatherRepositoryImpl(
              remoteDataSource: WeatherRemoteDataSourceImpl(
                client: http.Client(), // This is now required
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AlertProvider(
            alertRepository: AlertRepositoryImpl(
              localDataSource: AlertLocalDataSourceImpl(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const WeatherHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}