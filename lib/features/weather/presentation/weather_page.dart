import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_meteo/core/config/app_config.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${'app_name'.tr()} ${AppConfig.isMock ? "MOCK" : "PROD"}"),
      ),
      body: Center(
        child: Text(AppConfig.isMock ? "MOCK" : "PROD"),
      ),
    );
  }
}
