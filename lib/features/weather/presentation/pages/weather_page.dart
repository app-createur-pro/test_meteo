import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/features/weather/data/models/weather_model.dart';
import 'package:test_meteo/features/weather/presentation/providers/weather_provider.dart';
import 'package:test_meteo/features/weather/presentation/widgets/weather_icon.dart';

import '../widgets/hourly_forecast.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "${'app_name'.tr()} ${AppConfig.isMock ? "MOCK" : "PROD"}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: weatherAsync.when(
        data: (weather) => _WeatherContent(weather),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Erreur : $error")),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherModel weather;
  const _WeatherContent(this.weather);

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final hourly = weather.hourly; // ✅ Passe toute la liste sans la tronquer !

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.timezone,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          WeatherIcon(current.weather.first.icon),
          Text(
            "${current.temp.toInt()}°C",
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text(
            current.weather.first.description,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _WeatherMetrics(current),
          const SizedBox(height: 20),
          HourlyForecast(hourly), // ✅ Passe toute la liste à HourlyForecast
        ],
      ),
    );
  }
}

class _WeatherMetrics extends StatelessWidget {
  final WeatherCurrent current;
  const _WeatherMetrics(this.current);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MetricCard("humidity".tr(), "${current.humidity}%", Icons.water_drop),
        _MetricCard("uv_index".tr(), "${current.uvi}", Icons.wb_sunny),
        _MetricCard("wind".tr(), "${current.wind_speed} m/s", Icons.air),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
