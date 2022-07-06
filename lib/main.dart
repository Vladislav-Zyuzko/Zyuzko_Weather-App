import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_app/pages/main_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(weather: Weather()),
    ),
  );
}
