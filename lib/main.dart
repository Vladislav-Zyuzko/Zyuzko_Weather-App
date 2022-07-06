import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DioDemo(weather: Weather()),
    ),
  );
}

class DioDemo extends StatefulWidget {
  const DioDemo({super.key, required this.weather});

  final Weather weather;

  @override
  State<DioDemo> createState() => _DioDemoState();
}

class _DioDemoState extends State<DioDemo> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DioDemo"),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset("assets/weather_icons/cloudy_moon.png"),
              ElevatedButton(
                onPressed: () {
                  print(widget.weather.findCity("Омск"));
                  widget.weather.getNowWeather();
                },
                child: const Text(
                  "Отправить запрос",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
