import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/model.dart'; // Import the correct path to Weather

class WeatherService {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?q=$cityName&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        // Parse the response body into a Weather object using the Weather.fromJson method
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      LocationPermission permission = await _getLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
      return city ?? "Unknown";
    } catch (e) {
      throw Exception('Failed to fetch current city: $e');
    }
  }

  Future<LocationPermission> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
}
