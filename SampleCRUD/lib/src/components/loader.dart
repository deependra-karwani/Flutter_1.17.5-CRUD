import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Loading View'),
      // ),
      body: Center(
        child: Loading(indicator: BallPulseIndicator(), size: 100.0),
      )
    );
  }
}