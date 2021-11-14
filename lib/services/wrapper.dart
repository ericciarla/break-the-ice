import 'package:btiui/models/location_model.dart';
import 'package:btiui/models/nearby_user_model_db.dart';
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
  final UserAtt user;
  Wrapper(this.user);
  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);
    final dbService2 = Provider.of<UserAttDbInfo>(context, listen: false);
    return StreamBuilder<UserAttDB>(
        stream: dbService.getUserDb(),
        builder: (context, snapshot2) {
          if (snapshot2.connectionState == ConnectionState.active &&
              snapshot2.hasData) {
            dbService2.setUser(snapshot2.data!);
            return StreamBuilder<List<UserLoc>>(
                stream: dbService.nearbyUsers,
                builder: (context, snapshot3) {
                  if (snapshot3.connectionState == ConnectionState.active &&
                      snapshot3.hasData) {
                    print("s3");
                    print(snapshot3.data);
                    return Home(
                        nUserAttr: snapshot3.data!, UserData: snapshot2.data!);
                  }
                  return Loading();
                });
          }
          return Loading();
        });
  }
}
