import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/core/config/flavor.dart';
import 'package:test_meteo/features/weather/data/service/weather_service.dart';
import 'package:test_meteo/features/weather/data/models/weather_model.dart';

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final Flavor flavor;

  // Détermine le Flavor en fonction de AppConfig ou d'une autre logique
  if (AppConfig.isMock) {
    flavor = Flavor.mock;
  } else if (AppConfig.useDartServer) {
    flavor = Flavor.dartServer;
  } else {
    flavor = Flavor.prod;
  }

  final weatherService = WeatherService(flavor: flavor);

  // Exemple de coordonnées (Paris)
  return weatherService.fetchWeather(48.8566, 2.3522);
});
