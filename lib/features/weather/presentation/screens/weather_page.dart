import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_meteo/features/weather/presentation/providers/weather_provider.dart';

import '../../../../core/config/app_config.dart';
import '../../data/models/weather_model.dart';

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
    final hourly = weather.hourly.take(6).toList();

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
          _WeatherIcon(current.weather.first.icon),
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
          _HourlyForecast(hourly),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final String iconCode;
  const _WeatherIcon(this.iconCode);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://openweathermap.org/img/wn/$iconCode@2x.png",
      width: 100,
      height: 100,
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

class _HourlyForecast extends StatelessWidget {
  final List<WeatherHourly> hourly;
  const _HourlyForecast(this.hourly);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("hourly_forecast".tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final hour = hourly[index];
              return _HourlyCard(hour);
            },
          ),
        ),
      ],
    );
  }
}

class _HourlyCard extends StatelessWidget {
  final WeatherHourly hour;
  const _HourlyCard(this.hour);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm()
        .format(DateTime.fromMillisecondsSinceEpoch(hour.dt * 1000));
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          _WeatherIcon(hour.weather.first.icon),
          Text("${hour.temp.toInt()}°C", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
