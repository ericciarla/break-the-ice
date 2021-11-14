import 'package:btiui/pages/signup.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/pages/Loading.dart';
import 'package:btiui/pages/home.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:btiui/main.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break The Ice',
      theme: ThemeData(
        primaryColor: Color(0xff79DFFF),
      ),
      home: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
