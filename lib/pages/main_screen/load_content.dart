import 'package:flutter/material.dart';

class LoadContent extends StatelessWidget {
  const LoadContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/gifs/loader.gif",
        scale: 5.0,
      ),
    );
  }
}
