import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/core/config/flavor.dart';
import 'package:test_meteo/features/weather/data/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.openweathermap.org/data/3.0/onecall";
  final String _dartServerUrl = "http://localhost:8080/weather";

  final Flavor flavor;

  WeatherService({required this.flavor});

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    switch (flavor) {
      case Flavor.mock:
        return _fetchMockWeather();
      case Flavor.dartServer:
        return _fetchFromDartServer();
      case Flavor.prod:
        return _fetchFromAPI(lat, lon);
    }
  }

  Future<WeatherModel> _fetchFromAPI(double lat, double lon) async {
    final String apiKey = AppConfig.instance.apiKey;
    if (apiKey.isEmpty) {
      throw Exception("❌ Aucune API Key trouvée !");
    }

    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          "lat": lat,
          "lon": lon,
          "appid": apiKey,
          "exclude": "minutely,alerts",
          "units": "metric",
          "lang": "fr"
        },
      );

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw Exception("❌ Erreur API météo : $e");
    }
  }

  Future<WeatherModel> _fetchFromDartServer() async {
    try {
      final response = await _dio.get(_dartServerUrl);

      final Map<String, dynamic> data =
          response.data is String ? jsonDecode(response.data) : response.data;

      return WeatherModel.fromJson(data);
    } catch (e) {
      throw Exception("Erreur serveur Dart : $e");
    }
  }

  /// 🔹 Charge les données Mock depuis les fichiers CSV
  Future<WeatherModel> _fetchMockWeather() async {
    final currentWeather = await _loadCurrentWeather();
    final hourlyForecast = await _loadHourlyForecast();

    return WeatherModel(
      lat: 48.8566,
      lon: 2.3522,
      timezone: "Europe/Paris",
      current: currentWeather,
      hourly: hourlyForecast,
    );
  }

  Future<WeatherCurrent> _loadCurrentWeather() async {
    final String csvString =
        await rootBundle.loadString('assets/mocks/weather_current.csv');
    final List<String> lines = csvString.split('\n');

    if (lines.length < 2) {
      throw Exception("CSV `weather_current.csv` vide ou mal formaté");
    }

    final List<String> values = lines[1].split(',');
    return WeatherCurrent(
      temp: double.parse(values[0]),
      humidity: int.parse(values[1]),
      uvi: double.parse(values[2]),
      wind_speed: double.parse(values[3]),
      weather: [
        WeatherCondition(
          main: values[4],
          description: values[5],
          icon: values[6],
        )
      ],
    );
  }

  Future<List<WeatherHourly>> _loadHourlyForecast() async {
    final String csvString =
        await rootBundle.loadString('assets/mocks/weather_hourly.csv');
    final List<String> lines = csvString.split('\n');

    if (lines.length < 2) {
      throw Exception("CSV `weather_hourly.csv` vide ou mal formaté");
    }

    return lines.skip(1).map((line) {
      final values = line.split(',');
      return WeatherHourly(
        dt: int.parse(values[0]),
        temp: double.parse(values[1]),
        weather: [
          WeatherCondition(
            main: values[2],
            description: values[3],
            icon: values[4],
          )
        ],
      );
    }).toList();
  }
}
