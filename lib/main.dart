import 'package:btiui/pages/editprofile.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/signup.dart';
import 'pages/login.dart';
import 'pages/welcome.dart';
import 'pages/somethingwentwrong.dart';
import 'pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Break The Ice',
        theme: ThemeData(
          primaryColor: Color(0xff79DFFF),
        ),
        home: Wrapper(),
      ),
    );
  }
}
