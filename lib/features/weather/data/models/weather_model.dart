import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final double lat;
  final double lon;
  final String timezone;
  final WeatherCurrent current;
  final List<WeatherHourly> hourly;

  WeatherModel({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.current,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@JsonSerializable()
class WeatherCurrent {
  final double temp;
  final int humidity;
  final double uvi;
  final double wind_speed;
  final List<WeatherCondition> weather;

  WeatherCurrent({
    required this.temp,
    required this.humidity,
    required this.uvi,
    required this.wind_speed,
    required this.weather,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) =>
      _$WeatherCurrentFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherCurrentToJson(this);
}

@JsonSerializable()
class WeatherHourly {
  final int dt;
  final double temp;
  final List<WeatherCondition> weather;

  WeatherHourly({
    required this.dt,
    required this.temp,
    required this.weather,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherHourlyToJson(this);
}

@JsonSerializable()
class WeatherCondition {
  final String main;
  final String description;
  final String icon;

  WeatherCondition({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherConditionToJson(this);
}
