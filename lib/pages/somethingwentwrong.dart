import 'package:btiui/pages/signup.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/pages/SomethingWentWrong.dart';
import 'package:btiui/pages/home.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:btiui/main.dart';

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
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
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5a5a5a),
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
