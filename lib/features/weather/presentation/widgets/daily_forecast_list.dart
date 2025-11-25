import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyWeather> daily;

  const DailyForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '14-Day Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: daily.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final day = daily[index];
            return ListTile(
              leading: Text(
                DateFormat('E').format(day.date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              title: Text(day.condition),
              trailing: Text(
                '${day.maxTemp.toStringAsFixed(0)}° / ${day.minTemp.toStringAsFixed(0)}°',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }
}