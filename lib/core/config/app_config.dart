import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String apiKey;
  static late AppConfig instance;

  AppConfig._internal(this.flavor, this.apiKey);

  static void init({required Flavor flavor}) {
    final apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
    instance = AppConfig._internal(flavor, apiKey);
  }

  static bool get isMock => instance.flavor == Flavor.mock;
}
