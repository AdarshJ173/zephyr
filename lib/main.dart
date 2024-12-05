import 'package:flutter/material.dart';
import 'pages/weather_pages.dart'; // Ensure this path matches your directory structure

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zephyr - Weather App', // Updated title for clarity
      home: const WeatherPage(), // Use const for better performance
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Optional: Define light and dark theme colors if needed
        // brightness: Brightness.light, // Uncomment if you want to set the brightness
      ),
    );
  }
}
