import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DioDemo(),
    ),
  );
}

class DioDemo extends StatefulWidget {
  const DioDemo({Key? key}) : super(key: key);

  @override
  State<DioDemo> createState() => _DioDemoState();
}

class _DioDemoState extends State<DioDemo> {
  @override
  String APPID = '69856b5b43fc307c7b50ccafb0b06dbf';
  String city = 'Omsk,RU';
  String units = 'metric';

  void _sendRequest() async {
    Dio dio = Dio();
    Response response = await dio.request(
      'http://api.openweathermap.org/data/2.5/find',
      options: Options(method: 'GET'),
      queryParameters: <String, String>{
        'q': city,
        'units': units,
        'type': 'like',
        'APPID': APPID
      },
    );
    print(response.data['list']);
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
                onPressed: () => _sendRequest(),
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
