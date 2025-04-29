import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengingat Sholat',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
