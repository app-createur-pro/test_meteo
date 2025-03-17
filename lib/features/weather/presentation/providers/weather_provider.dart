import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_meteo/features/weather/data/service/weather_service.dart';
import 'package:test_meteo/features/weather/data/models/weather_model.dart';

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final weatherService = WeatherService();
  return weatherService.fetchWeather(48.8566, 2.3522); //Paris by default
});
