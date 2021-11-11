import 'package:btiui/models/location_model.dart';
import 'package:btiui/pages/editprofile.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:btiui/services/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/nearby_user_model_db.dart';
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
import 'package:location/location.dart';

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
          create: (_) => DatabaseService(),
        ),
        // Streams
        StreamProvider<UserAtt?>(
          initialData: null,
          create: (_) => AuthService().user,
        ),
        StreamProvider<UserAttDB?>(
          initialData: null,
          create: (_) => DatabaseService().UserAttDBs3,
        ),
        ChangeNotifierProvider<UserAttDbInfo?>(
          create: (_) => UserAttDbInfo(),
        ),
        StreamProvider<List<UserLoc>>(
          initialData: const <UserLoc>[],
          create: (_) => DatabaseService().nearbyUsers,
        ),
        StreamProvider<List<NearUserAttDB>>(
          initialData: const <NearUserAttDB>[],
          create: (_) => DatabaseService()
              .allNearbyUsersAttr(DatabaseService().nearbyUsers),
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
