import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/flavors/flavors_config.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${'app_name'.tr()} ${FlavorsConfig.isMock ? "MOCK" : "PROD"}"),
      ),
      body: Center(
        child: Text(FlavorsConfig.isMock ? "MOCK" : "PROD"),
      ),
    );
  }
}
