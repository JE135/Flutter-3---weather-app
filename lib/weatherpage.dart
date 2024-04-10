import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../service/service.dart'; // Correct the relative import path to service.dart
import 'model/model.dart'; // Correct the relative import path to weather_model.dart

final logger = Logger();

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(
      '6ffb3d788b4055253ae8dbf15c23c5e8'); // Replace 'YOUR_API_KEY' with your OpenWeatherMap API key
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e, stacktrace) {
      logger.e('Error fetching weather', error: e, stackTrace: stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: _weather != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather!.cityName,
                    style: const TextStyle(
                      color: Color.fromRGBO(36, 35, 35, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_weather!.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _weather!.description,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    _weather!.iconUrl,
                    scale: 0.8,
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
