import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/weather_model.dart';
import 'weather_icon.dart';

class HourlyForecast extends StatefulWidget {
  final List<WeatherHourly> hourly;
  const HourlyForecast(this.hourly, {super.key});

  @override
  HourlyForecastState createState() => HourlyForecastState();
}

class HourlyForecastState extends State<HourlyForecast> {
  final ScrollController _scrollController = ScrollController();
  List<WeatherHourly> _displayedHours = [];
  int _loadedHours = 6;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _displayedHours = widget.hourly.take(_loadedHours).toList();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _loadMoreHours();
    }
  }

  void _loadMoreHours() {
    if (_isLoading || _loadedHours >= widget.hourly.length) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loadedHours = (_loadedHours + 6).clamp(0, widget.hourly.length);
        _displayedHours = widget.hourly.take(_loadedHours).toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("hourly_forecast".tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _displayedHours.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _displayedHours.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return _HourlyCard(_displayedHours[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HourlyCard extends StatelessWidget {
  final WeatherHourly hour;
  const _HourlyCard(this.hour);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm()
        .format(DateTime.fromMillisecondsSinceEpoch(hour.dt * 1000));
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          WeatherIcon(hour.weather.first.icon),
          Text("${hour.temp.toInt()}°C", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
