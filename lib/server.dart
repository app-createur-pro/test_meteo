import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

final random = Random();
final faker = Faker();

String generateWeatherData() {
  final double currentTemp = 15.0 + random.nextDouble() * (25.0 - 15.0);
  final int humidity = faker.randomGenerator.integer(100, min: 50);
  final double uvi = random.nextDouble() * 10.0;
  final double windSpeed = random.nextDouble() * 10.0;

  final hourlyForecast = List.generate(9, (index) {
    final hour = 1710679200 + (index * 3600); // Ajoute 1 heure en secondes
    final double temp = 15.0 + random.nextDouble() * (20.0 - 15.0);
    final weather = {
      'main': faker.randomGenerator.element(['Clear', 'Clouds', 'Rain']),
      'description': faker.lorem.words(2).join(" "),
      'icon': faker.randomGenerator.element(['01d', '02d', '09d'])
    };
    return {
      'dt': hour,
      'temp': temp,
      'weather': [weather],
    };
  });

  final data = {
    'lat': 48.8566,
    'lon': 2.3522,
    'timezone': 'Europe/Paris',
    'current': {
      'temp': currentTemp,
      'humidity': humidity,
      'uvi': uvi,
      'wind_speed': windSpeed,
      'weather': [
        {
          'main': 'Clouds',
          'description': 'Ciel partiellement nuageux',
          'icon': '04d',
        }
      ]
    },
    'hourly': hourlyForecast,
  };

  return jsonEncode(data);
}

class WeatherServer {
  Handler get handler {
    final router = Router();

    router.get('/weather', (Request request) {
      final weatherData = generateWeatherData();
      return Response.ok(weatherData,
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}

Future<void> main() async {
  final server = WeatherServer();
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(server.handler);

  final serverAddress = InternetAddress.anyIPv4;
  const port = 8080;

  final serverInstance = await shelf_io.serve(handler, serverAddress, port);
  debugPrint(
      'Server listening at http://${serverInstance.address.host}:${serverInstance.port}');
}
