import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class MainContent extends StatefulWidget {
  const MainContent(
      {super.key, required this.weather, required this.weatherLog, required this.iconsMap, required this.forecastLog, required this.iconUrl});

  final Weather weather;
  final Map<String, String> iconsMap;
  final String iconUrl;
  final Map<String, dynamic> weatherLog;
  final List<dynamic> forecastLog;

  @override
  State<MainContent> createState() => _MainContent();
}

class _MainContent extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 50.0)),
        Text(
          'Погода ${widget.weather.getCityName()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 50.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: Image.asset(
                widget.iconUrl,
                scale: 1.2,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 30)),
            Text(
              '${widget.weatherLog['Температура'] ?? 0.toString()}°',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(
              vertical: 50.0, horizontal: 0.0),
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white70,
                    Colors.blueGrey,
                  ])),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  const Icon(Icons.water_drop,
                      color: Colors.blueGrey, size: 40.0),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text(
                    '${widget.weatherLog['Влажность'] ?? 0}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Icon(WeatherIcons.barometer,
                      color: Colors.blueGrey, size: 40.0),
                  const Padding(padding: EdgeInsets.only(top: 18.0)),
                  Text(
                    '${widget.weatherLog['Давление'] ?? 0}мм.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Icon(WeatherIcons.wind_beaufort_1,
                      color: Colors.blueGrey, size: 40.0),
                  const Padding(padding: EdgeInsets.only(top: 18.0)),
                  Text(
                    '${widget.weatherLog['Скорость ветра'].round() ?? 0}м/с',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  WindIcon(
                    degree: widget.weatherLog['Угол ветра'] ?? 90,
                    color: Colors.blueGrey,
                    size: 40.0,
                  ),
                  Text(
                    '${widget.weatherLog['Направление ветра'] ?? "С"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const Padding(padding: EdgeInsets.only(top: 30)),
        // const Text("Прогноз на 5 дней", style: TextStyle(
        //   color: Colors.white,
        //   fontSize: 30,
        //   fontWeight: FontWeight.bold,
        // ),),
        // const Padding(padding: EdgeInsets.only(top: 30)),
        Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.black45,
          height: 220,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.forecastLog.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Text(
                      "${widget.forecastLog[index]['День']} ${widget.forecastLog[index]['Месяц']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.forecastLog[index]['Время']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(widget.iconsMap[widget.forecastLog[index]['Иконка']] ?? "assets/gifs/loader.gif", scale: 1.5,),
                    Text(
                      "${widget.forecastLog[index]['Температура']}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
                //return Icon(WeatherIcons.day_sunny);
              }
          ),
        ),
      ],
    );
  }
}
