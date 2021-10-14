import 'package:btiui/models/user_model.dart';
import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/loading.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/pages/welcome.dart';
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
              //print(user.email);
              return Home();
            }
          } else {
            return Loading();
          }
        });
  }
}
