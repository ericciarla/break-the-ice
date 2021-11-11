import 'package:btiui/models/user_model_db.dart';
import 'package:flutter/material.dart';

class UserAttDbInfo extends ChangeNotifier {
  late UserAttDB? user;

  UserAttDbInfo({this.user});

  setUser(UserAttDB user2) {
    user = user2;
    //notifyListeners();
  }
}
