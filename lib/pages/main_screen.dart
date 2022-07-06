import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.weather});

  final Weather weather;

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final iconsMap = <String, String>{
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

  void getWeatherData() async {
    weatherLog = await widget.weather.getNowWeather();
    setState(() {
      iconUrl = iconsMap[weatherLog['Иконка']] ??
          'assets/weather_icons/no_connect_white.png';
    });
  }

  String getTemp() {
    return weatherLog['Температура'] != null
        ? '${weatherLog['Температура'].toString()}°'
        : '';
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Введите населенный пункт"),
                  content: TextField(
                    onChanged: (String str) {
                      widget.weather.setCityName(str);
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        int key = await widget.weather.findCity(widget.weather.getCityName());
                        print(key);
                        setState(() {
                          getWeatherData();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Принять"),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => getWeatherData(),
            alignment: Alignment.topLeft,
            icon: const Icon(
              Icons.change_circle_outlined,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50.0)),
              Text(
                'Погода ${widget.weather.getCityName()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 50.0)),
              Row(
                children: [
                  Image.asset(iconUrl),
                  const Padding(padding: EdgeInsets.only(left: 30)),
                  Text(
                    getTemp(),
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black38,
    );
  }
}
