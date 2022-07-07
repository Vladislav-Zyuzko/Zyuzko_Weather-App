import 'package:flutter/material.dart';

class InvalidContent extends StatelessWidget {
  const InvalidContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            Image.asset('assets/weather_icons/no_connect_white.png'),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            Container(
              width: 350,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Text(
                "Не удалось подключиться к серверу. Проверьте ваше интернет-соединение.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }
}
