import 'package:btiui/models/location_model.dart';
import 'package:btiui/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

Geoflutterfire geo = Geoflutterfire();

class Globals {
  static DateTime? lastRun = DateTime.now().subtract(Duration(seconds: 60));
  static getLastRun() {
    return lastRun;
  }

  static changeLastRun(DateTime a) {
    lastRun = a;
  }

  static GeoFirePoint curLoc = geo.point(latitude: 44, longitude: -71);

  static getCurLoc() {
    return curLoc;
  }

  static changeCurLoc(GeoFirePoint a) {
    curLoc = a;
  }

  static UserLoc lastUserLoc = UserLoc(
      "", Timestamp.now(), curLoc.data, "", "", "", "", "", false, "", "", "");

  static getLastUserLoc() {
    return lastUserLoc;
  }

  static changeLastUserLoc(UserLoc a) {
    lastUserLoc = a;
  }
}
