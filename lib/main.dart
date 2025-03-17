import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_meteo/core/config/app_config.dart';
import 'package:test_meteo/core/config/flavor.dart';
import 'package:test_meteo/core/navigation/locales.dart';

import 'app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  AppConfig.init(flavor: Flavor.mock);
  await initApp();
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: locales,
      path: 'assets/translations',
      fallbackLocale: localeEn,
      child: const App(),
    ),
  );
}
