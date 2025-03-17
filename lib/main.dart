import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/flavors/flavor.dart';
import 'core/flavors/flavors_config.dart';
import 'core/navigation/locales.dart';

void main() async {
  FlavorsConfig.init(Flavor.mock);
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
