import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_app/pages/main_screen/main_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Home(weather: Weather()),
    ),
  );
}
