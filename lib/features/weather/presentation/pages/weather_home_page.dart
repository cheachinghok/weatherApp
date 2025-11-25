import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/location_search.dart';
import 'alerts_page.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherData();
    });
  }

  void _loadWeatherData() {
    final provider = context.read<WeatherProvider>();
    provider.getCurrentLocationWeather();
  }

  void _useMockData() {
    final provider = context.read<WeatherProvider>();
    provider.setMockDataForTesting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlertsPage(),
                ),
              );
              // showSearch(
              //   context: context,
              //   delegate: LocationSearch(),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading weather data...'),
                ],
              ),
            );
          }

          if (weatherProvider.error.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      weatherProvider.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _loadWeatherData,
                          child: const Text('Try Again'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: _useMockData,
                          child: const Text('Use Demo Data'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: LocationSearch(),
                        );
                      },
                      child: const Text('Search for a city'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (weatherProvider.currentWeather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No weather data available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWeatherData,
                    child: const Text('Load Weather Data'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await weatherProvider.getCurrentLocationWeather();
            },
            child: ListView(
              children: [
                CurrentWeatherCard(weather: weatherProvider.currentWeather!),
                const SizedBox(height: 16),
                if (weatherProvider.hourlyForecast.isNotEmpty)
                  HourlyForecastList(hourly: weatherProvider.hourlyForecast),
                const SizedBox(height: 16),
                if (weatherProvider.dailyForecast.isNotEmpty)
                  DailyForecastList(daily: weatherProvider.dailyForecast),
              ],
            ),
          );
        },
      ),
    );
  }
}