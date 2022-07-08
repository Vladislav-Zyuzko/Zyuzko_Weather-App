import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_app/pages/main_screen/main_screen.dart';
import 'package:weather_app/pages/init_screen/init_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  var userBox = await Hive.openBox('UserBox');

  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: userBox.isEmpty ? '/init' : '/',
      routes: {
        '/': (context) => Home(weather: Weather(), userBox: userBox),
        '/init': (context) => InitContent(weather: Weather(), userBox: userBox),
      },
    ),
  );
}
