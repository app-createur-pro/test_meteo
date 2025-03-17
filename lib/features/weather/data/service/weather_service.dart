import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/features/weather/data/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.openweathermap.org/data/3.0/onecall";

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    if (AppConfig.isMock) {
      return _fetchMockWeather();
    }

    final String apiKey = AppConfig.instance.apiKey;
    if (apiKey.isEmpty) {
      throw Exception("aucune API Key trouvée !");
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
      throw Exception("Erreur lors de la récupération des données météo : $e");
    }
  }

  /// 📌 Charge les données Mock depuis les fichiers CSV
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

  /// 🔹 Charge les données actuelles depuis `weather_current.csv`
  Future<WeatherCurrent> _loadCurrentWeather() async {
    final String csvString =
        await rootBundle.loadString('assets/mocks/weather_current.csv');
    final List<String> lines = csvString.split('\n');

    if (lines.length < 2) throw Exception("Fichier CSV vide ou mal formaté");

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

  /// 🔹 Charge les prévisions horaires depuis `weather_hourly.csv`
  Future<List<WeatherHourly>> _loadHourlyForecast() async {
    final String csvString =
        await rootBundle.loadString('assets/mocks/weather_hourly.csv');
    final List<String> lines = csvString.split('\n');

    if (lines.length < 2) throw Exception("Fichier CSV vide ou mal formaté");

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
