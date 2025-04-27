// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';

class WeatherForecast {
  final DateTime date;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      temperature: json['temperature'].toDouble(),
      condition: json['condition'],
      icon: json['icon'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'temperature': temperature,
      'condition': condition,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  // Get weather icon based on condition
  IconData getWeatherIcon() {
    switch (icon) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}

// Mock data for weather forecast
class WeatherService {
  static List<WeatherForecast> getMockForecast() {
    final now = DateTime.now();
    return [
      WeatherForecast(
        date: now,
        temperature: 29,
        condition: 'Partly cloudy',
        icon: 'partly_cloudy',
        humidity: 65,
        windSpeed: 12,
      ),
      WeatherForecast(
        date: now.add(const Duration(days: 1)),
        temperature: 30,
        condition: 'Sunny',
        icon: 'sunny',
        humidity: 60,
        windSpeed: 10,
      ),
      WeatherForecast(
        date: now.add(const Duration(days: 2)),
        temperature: 28,
        condition: 'Light rain',
        icon: 'rainy',
        humidity: 75,
        windSpeed: 15,
      ),
      WeatherForecast(
        date: now.add(const Duration(days: 3)),
        temperature: 27,
        condition: 'Cloudy',
        icon: 'cloudy',
        humidity: 70,
        windSpeed: 8,
      ),
      WeatherForecast(
        date: now.add(const Duration(days: 4)),
        temperature: 29,
        condition: 'Sunny',
        icon: 'sunny',
        humidity: 55,
        windSpeed: 7,
      ),
    ];
  }
}
