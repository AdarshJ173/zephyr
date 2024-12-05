class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Safely parse the JSON data with null checks
    final cityName = json['name'] ?? 'Unknown City';
    final temperature = (json['main']['temp'] is num)
        ? (json['main']['temp'] as num).toDouble()
        : 0.0; // Default temperature if not available
    final mainCondition =
        (json['weather'] != null && json['weather'].isNotEmpty)
            ? json['weather'][0]['main'] ?? 'Unknown'
            : 'Unknown'; // Default condition if not available

    return Weather(
      cityName: cityName,
      temperature: temperature,
      mainCondition: mainCondition,
    );
  }
}
