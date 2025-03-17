import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/core/config/flavor.dart';

import 'main.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  AppConfig.init(flavor: Flavor.dartServer);
  await initApp();
}
