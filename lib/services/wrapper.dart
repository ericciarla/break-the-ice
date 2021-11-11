import 'package:btiui/models/user_model.dart';
import 'package:btiui/models/user_model_db.dart';
import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/loading.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/pages/welcome.dart';
import 'package:btiui/services/database.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserAtt?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<UserAtt?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserAtt? user = snapshot.data;
            if (user == null) {
              return Welcome();
            } else {
              final dbService = Provider.of<DatabaseService>(context);
              final dbService2 =
                  Provider.of<UserAttDbInfo>(context, listen: false);
              return StreamBuilder<UserAttDB>(
                  stream: dbService.getUserDb(),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.active &&
                        snapshot2.hasData) {
                      dbService2.setUser(snapshot2.data!);
                      return Home();
                    }
                    return Loading();
                  });
            }
          } else {
            return Loading();
          }
        });
  }
}
