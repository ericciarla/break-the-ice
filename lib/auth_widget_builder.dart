import 'package:btiui/models/user_model.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/database.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/location_model.dart';
import 'models/nearby_user_model_db.dart';
import 'models/user_model_db.dart';

/// Used to create user-dependant objects that need to be accessible by all widgets.
/// This widget should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<UserAtt?>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserAtt?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          final UserAtt user = snapshot.data!;
          //authService.signOut(context);
          return MultiProvider(providers: [
            StreamProvider<UserAtt?>(
              initialData: user,
              create: (_) => AuthService().user,
            ),
            StreamProvider<UserAttDB?>(
              initialData: null,
              create: (_) => DatabaseService().UserAttDBs3,
            ),
            
            StreamProvider<List<UserLoc>>(
              initialData: const <UserLoc>[],
              create: (_) => DatabaseService().nearbyUsers,
            ),
            FutureProvider<List<NearUserAttDB>>(
              initialData: const <NearUserAttDB>[],
              create: (_) => DatabaseService().allNearbyUsersAttr([]),
            ),
          ], child: builder(context, snapshot));
        }
        return builder(context, snapshot);
      },
    );
  }
}