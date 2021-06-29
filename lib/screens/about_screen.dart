import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Made by Wanatabe Yuu!'),
      ),
      appBar: AppBar(),
    );
  }
}
