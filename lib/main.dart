import 'package:btiui/models/location_model.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/globals.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:btiui/services/wrapper.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'auth_widget.dart';
import 'auth_widget_builder.dart';
import 'models/nearby_user_model_db.dart';
import 'models/user_model_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'services/database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseService().getPermission();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics();

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
        ChangeNotifierProvider<UserAttDbInfo?>(
          create: (_) => UserAttDbInfo(),
        ),
      ],
      child: MaterialApp(
        title: 'Break The Ice',
        theme: ThemeData(
          primaryColor: const Color(0xff79DFFF),
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: AuthWidgetBuilder(builder: (context, userSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AuthWidget(userSnapshot: userSnapshot),
          );
        }),
      ),
    );
  }
}
