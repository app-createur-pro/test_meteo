import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  const WeatherIcon(this.iconCode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://openweathermap.org/img/wn/$iconCode@2x.png",
      width: 100,
      height: 100,
    );
  }
}
