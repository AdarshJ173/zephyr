import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../model/weather_model.dart';
import '../services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _cityController = TextEditingController();
  final String apiKey =
      'b8b0417c86814cb4007e9aaffa24c326'; // Replace with your actual API key
  late WeatherService _weatherService;
  Weather? _weather;
  bool _isLoading = false;
  bool _isDarkMode = false;
  String? _errorMessage;

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/cloud1.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain2.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'snow':
        return 'assets/snow1.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'haze':
        return 'assets/haze1.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService(apiKey);
    _getCurrentCity(); // Automatically fetch current city on launch
  }

  Future<void> _getCurrentCity() async {
    String city = await _weatherService.getCurrentCity();
    _cityController.text = city; // Set city in TextField
    await _searchWeather(); // Automatically fetch weather for the current city
  }

  Future<void> _searchWeather() async {
    if (_cityController.text.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading animation
        _errorMessage = null; // Reset error message
      });

      FocusScope.of(context).unfocus(); // Dismiss the keyboard

      try {
        final weather = await _weatherService.getWeather(_cityController.text);
        setState(() {
          _weather = weather;
          _isLoading = false; // Hide loading animation
        });
      } catch (e) {
        setState(() {
          _weather = null;
          _isLoading = false; // Hide loading animation
          _errorMessage =
              'Unable to fetch weather. Please try again.'; // Set error message
        });
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Toggle dark mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ZEPHYR',
            style: TextStyle(
              fontSize: 37.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
            ),
          ),
          centerTitle: true,
          elevation: 4.7,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
              iconSize: 34,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  getWeatherAnimation(_weather?.mainCondition),
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 30),
                    const SizedBox(width: 8),
                    if (_weather != null)
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                          fontSize: 47,
                          // fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        "Location",
                        style: TextStyle(fontSize: 24),
                      ),
                  ],
                ),
                const SizedBox(height: 0),
                if (_isLoading)
                  const CircularProgressIndicator() // Show loading animation
                else if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (_weather != null)
                  Column(
                    children: [
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: const TextStyle(
                          fontSize: 37,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _weather?.mainCondition ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 25, fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                else
                  const Text(
                      'Unable to fetch weather'), // Display message if no weather data is available
                const SizedBox(height: 40),
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchWeather, // Trigger search
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
