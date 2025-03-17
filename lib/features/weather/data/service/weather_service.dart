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

  Future<WeatherModel> _fetchMockWeather() async {
    final String jsonString =
        await rootBundle.loadString('assets/mocks/weather_mock.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return WeatherModel.fromJson(jsonData);
  }
}
