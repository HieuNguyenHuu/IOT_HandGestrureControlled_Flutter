import 'package:flutter/material.dart';

class car_splash extends StatefulWidget {
  //car_splash({Key key}) : super(key: key);

  @override
  _car_splashState createState() => _car_splashState();
}

class _car_splashState extends State<car_splash> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ghg',
        style: TextStyle(
          color: Colors.cyan,
          fontSize: 30.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
