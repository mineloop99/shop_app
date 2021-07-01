import 'package:flutter/material.dart';

void main() => runApp(GreatPlaceApp());

class GreatPlaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Places',
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
