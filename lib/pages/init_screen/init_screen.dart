import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitContent extends StatefulWidget {
  const InitContent({super.key, required this.weather, required this.userBox});

  final Weather weather;
  final Box userBox;

  @override
  State<InitContent> createState() => _InitContentState();
}

class _InitContentState extends State<InitContent> {

  @override
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
        centerTitle: true,
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
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            const Padding(padding: EdgeInsets.only(top: 200)),
            Container(
              padding: EdgeInsets.all(15),
              width: 320,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                "Добро пожаловать в Like Weather!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            ElevatedButton(
                onPressed: () {
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
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text("Принять"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Получить прогноз", style: TextStyle(
                  fontSize: 20,
                ),)
            )
          ]),
        ]),
      ),
    );
  }
}
