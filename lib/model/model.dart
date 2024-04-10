class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String iconUrl;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconUrl:
          'https://openweathermap.org/img/w/${json['weather'][0]['icon']}.png',
    );
  }
}
