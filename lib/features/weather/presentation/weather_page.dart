import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app_name'.tr())),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Aller aux détails'),
        ),
      ),
    );
  }
}
