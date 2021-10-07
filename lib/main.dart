import 'package:btiui/pages/editprofile.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/signup.dart';
import 'pages/login.dart';
import 'pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Color(0xff79DFFF);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break The Ice',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: Home(),
    );
  }
}
