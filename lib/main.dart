import 'package:btiui/pages/editprofile.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/user_model_db.dart';
import 'pages/home.dart';
import 'pages/signup.dart';
import 'pages/login.dart';
import 'pages/welcome.dart';
import 'pages/somethingwentwrong.dart';
import 'pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'services/database.dart';

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
    //final user = Provider.of<UserAtt?>(context);
    //print(user?.uid);
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(uid: ' '),
        ),
        // Streams
        StreamProvider<UserAtt?>(
          initialData: null,
          create: (_) => AuthService().user,
        ),
        StreamProvider<QuerySnapshot?>(
          initialData: null,
          create: (_) => DatabaseService(uid: ' ').getDataStreamSnapshots(),
        ),
        StreamProvider<List<UserAttDB>>(
          initialData: const <UserAttDB>[],
          create: (_) => DatabaseService(uid: '').UserAttDBs2,
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
