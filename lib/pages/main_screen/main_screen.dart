import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_app/pages/main_screen/main_content.dart';
import 'package:weather_app/pages/main_screen/load_content.dart';
import 'package:weather_app/pages/main_screen/invalid_content.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.weather, required this.userBox});

  final Weather weather;
  final Box userBox;

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  Map<String, String> iconsMap = <String, String>{
    '01d': 'assets/weather_icons/clear_sun.png',
    '01n': 'assets/weather_icons/clear_moon.png',
    '02d': 'assets/weather_icons/cloudy_sun.png',
    '02n': 'assets/weather_icons/cloudy_moon.png',
    '03d': 'assets/weather_icons/cloudy.png',
    '03n': 'assets/weather_icons/cloudy.png',
    '04d': 'assets/weather_icons/cloudy.png',
    '04n': 'assets/weather_icons/cloudy.png',
    '09d': 'assets/weather_icons/clear_rain.png',
    '09n': 'assets/weather_icons/clear_rain.png',
    '10d': 'assets/weather_icons/cloudy_rain.png',
    '10n': 'assets/weather_icons/cloudy_rain.png',
    '11d': 'assets/weather_icons/storm.png',
    '11n': 'assets/weather_icons/storm.png',
    '13d': 'assets/weather_icons/snow.png',
    '13n': 'assets/weather_icons/snow.png',
    '50d': 'assets/weather_icons/wind.png',
    '50n': 'assets/weather_icons/wind.png',
  };

  String iconUrl = 'assets/weather_icons/no_connect_white.png';
  Map<String, dynamic> weatherLog = <String, dynamic>{};
  List<dynamic> forecastLog = [];

  void getWeatherData() async {
    weatherLog = <String, dynamic>{};
    weatherLog = await widget.weather.getNowWeather();
    setState(() {
      iconUrl = iconsMap[weatherLog['Иконка']] ??
          'assets/weather_icons/no_connect_white.png';
    });
  }

  void getForecastData() async {
    forecastLog = [];
    forecastLog = await widget.weather.getLongForecast();
    setState(() {
      iconUrl = iconsMap[weatherLog['Иконка']] ??
          'assets/weather_icons/no_connect_white.png';
    });
  }

  dynamic returnContent() {
      if (widget.weather.getStatus()) {
        if (weatherLog.isNotEmpty) {
          return MainContent(weather: widget.weather, weatherLog: weatherLog,
              forecastLog: forecastLog, iconsMap: iconsMap, iconUrl: iconUrl);
        } else { return const LoadContent(); }
      } else {return const InvalidContent();}
    }

  void enterCityAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Введите населенный пункт"),
          content: TextField(
            onChanged: (String str) {
              widget.weather.setCityName(str);
              widget.userBox.put('city', str);
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                int key = await widget.weather
                    .findCity(widget.weather.getCityName());
                print(key);
                setState(() {
                  getWeatherData();
                  getForecastData();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Принять"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.userBox.isNotEmpty) {widget.weather.setCityName(widget.userBox.get('city'));}
    getWeatherData();
    getForecastData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Like Weather',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => enterCityAlert(),
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getWeatherData();
                getForecastData();
              });
              },
            alignment: Alignment.topLeft,
            icon: const Icon(
              Icons.change_circle_outlined,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade900,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: returnContent(),
      ),
    );
  }
}
