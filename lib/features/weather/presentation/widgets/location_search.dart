import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';

class LocationSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Enter a location to search'),
      );
    }

    return FutureBuilder<List<String>>(
      future: _getLocationSuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final suggestions = snapshot.data ?? [];

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final location = suggestions[index];
            return ListTile(
              title: Text(location),
              onTap: () {
                context.read<WeatherProvider>().getWeatherByLocation(location);
                close(context, location);
              },
            );
          },
        );
      },
    );
  }

  Future<List<String>> _getLocationSuggestions(String query) async {
    // For now, return some mock suggestions
    // In a real app, you would call a geocoding API here
    await Future.delayed(const Duration(milliseconds: 500));
    
    final cities = [
      'London',
      'New York',
      'Tokyo',
      'Paris',
      'Sydney',
      'Berlin',
      'Moscow',
      'Dubai',
      'Singapore',
      'Toronto',
    ];
    
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}