import 'package:btiui/models/user_model.dart';
import 'package:btiui/models/location_model.dart';
import 'package:btiui/models/nearby_user_model_db.dart';
import 'package:btiui/models/waves_model.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/user_model_db.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'globals.dart';

class DatabaseService {
  final CollectionReference userAttrCollection =
      FirebaseFirestore.instance.collection('userAttr');

  final CollectionReference reportedUserAttrCollection =
      FirebaseFirestore.instance.collection('Reported');

  final CollectionReference wavesUserAttrCollection =
      FirebaseFirestore.instance.collection('Waves');

  // Edit Profile - Working
  Future updateUserData(String fname, String headline, String f1, String f2,
      String f3, String profileURL, bool hidden, List blocked) async {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";

    return await userAttrCollection.doc(userId).set({
      'fname': fname,
      'headline': headline,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'profileURL': profileURL,
      'hidden': hidden,
      'blocked': blocked,
    });
  }

  // Toggle hide profile - working
  Future hideUser(bool hidden) async {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    return await userAttrCollection.doc(userId).update({
      'hidden': hidden,
    });
  }

  Future setSeenWave(String notif_id) async {
    return await wavesUserAttrCollection.doc(notif_id).update({
      'seen': true,
    });
  }

  // Toggle hide profile - working
  Future blockUser(String blockedUID) async {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    List<String> list1 = [];
    list1.add(blockedUID);
    print(blockedUID + " blocked");
    return await userAttrCollection.doc(userId).update({
      'blocked': FieldValue.arrayUnion(list1),
    });
  }

  Future reportUser(String reportedUID) async {
    print(reportedUID + " reported");
    return await reportedUserAttrCollection.doc(reportedUID).set({
      'time': DateTime.now(),
    });
  }

  Future reportUser2(
      String reportedUID, String reporterUID, String message) async {
    print(reportedUID + " reported");
    return await reportedUserAttrCollection
        .doc(reportedUID + Timestamp.now().toString())
        .set({
      'Reported_User': reportedUID,
      'Submitter': reporterUID,
      'Message': message,
      'time': DateTime.now(),
    });
  }

  Future wavetoUser(
      String receiver_uid,
      String receiver_fname,
      String uid,
      String fname,
      String lastActive,
      String headline,
      String f1,
      String f2,
      String f3,
      String imageID,
      String message) async {
    print(fname + " waved at " + receiver_fname + ": " + message);
    return await wavesUserAttrCollection
        .doc(uid + Timestamp.now().toString())
        .set({
      'receiver_uid': receiver_uid,
      'receiver_fname': receiver_fname,
      'uid': uid,
      'fname': fname,
      'lastActive': lastActive,
      'headline': headline,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'imageID': imageID,
      'message': message,
      'time': DateTime.now(),
      'seen': false
    });
  }

  // Format list of user info - working
  List<UserAttDB> userAttDBFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserAttDB(
          doc.get('fname') ?? " ",
          doc.get('headline') ?? " ",
          doc.get('f1') ?? " ",
          doc.get('f2') ?? " ",
          doc.get('f3') ?? " ",
          doc.get('hidden') ?? " ",
          doc.get('profileURL') ?? " ",
          doc.get('blocked') ?? " ");
    }).toList();
  }

  // Format own user info - working
  UserAttDB userAttDBFromSnapshotNL(DocumentSnapshot snapshot) {
    var doc = snapshot;
    return UserAttDB(
        doc.get('fname') ?? " ",
        doc.get('headline') ?? " ",
        doc.get('f1') ?? " ",
        doc.get('f2') ?? " ",
        doc.get('f3') ?? " ",
        doc.get('hidden') ?? " ",
        doc.get('profileURL') ?? " ",
        doc.get('blocked') ?? " ");
  }

  // Format own user info - working
  NearUserAttDB NearuserAttDBFromSnapshotNL(DocumentSnapshot snapshot) {
    var doc = snapshot;
    return NearUserAttDB(
      doc.get('uid') ?? " ",
      doc.get('lastActive') ?? " ",
      doc.get('distance') ?? " ",
      doc.get('fname') ?? " ",
      doc.get('headline') ?? " ",
      doc.get('f1') ?? " ",
      doc.get('f2') ?? " ",
      doc.get('f3') ?? " ",
      doc.get('hidden') ?? " ",
      doc.get('profileURL') ?? " ",
    );
  }

  // Get and stream individual user doc - working
  Stream<UserAttDB> get UserAttDBs3 async* {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    var document =
        userAttrCollection.doc(userId).snapshots().map(userAttDBFromSnapshotNL);
    yield* document;
  }

  Stream<UserAttDB> getUserDb() async* {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    var document =
        userAttrCollection.doc(userId).snapshots().map(userAttDBFromSnapshotNL);
    yield* document;
  }

  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');
  Geoflutterfire geo = Geoflutterfire();
  Location location = Location();

  // Location update - working
  Future updateLocation(
      String fname,
      String headline,
      String f1,
      String f2,
      String f3,
      String profileURL,
      bool hidden,
      bool first,
      String uid,
      GeoFirePoint point,
      List blocked) async {
    Position? pos;
    DateTime lr;
    lr = Globals.getLastRun();
    String userId = uid;
    final User? user = await AuthService().getCurrentUser();

    String loggedinuid = user?.uid ?? " ";
    if (uid != loggedinuid) {
      print("not matching user id");
      return null;
    }

    if (userId == "" ||
        (DateTime.now().difference(lr) < Duration(seconds: 3) &&
            first == false) ||
        Globals.getLastUserLoc() ==
            UserLoc(uid, null, point.data, fname, headline, f1, f2, f3, hidden,
                profileURL, "", "", blocked)) {
      print("Not sent");
      return null;
    } else {
      //GeoFirePoint point =
      //    geo.point(latitude: 43.13640928556907, longitude: -70.92660689063206);
      //pos = await _determinePosition();
      //GeoFirePoint point =
      //    geo.point(latitude: pos.latitude, longitude: pos.longitude);
      //if (point == geo.point(latitude: 44, longitude: -71)) {
      //  Fluttertoast.showToast(
      //      msg: "Looking for location...",
      //      toastLength: Toast.LENGTH_SHORT,
      //      gravity: ToastGravity.CENTER,
      //      timeInSecForIosWeb: 5,
      //      backgroundColor: Colors.red,
      //      textColor: Colors.white,
      //      fontSize: 16.0);
      //}

      print("Sent");
      if (userId == "7hstPLPz9pVCU64jw0TswzRCT7A2") {
        await locationCollection.doc("23irbgiu43he98d").set({
          'position': point.data,
          'name': "23irbgiu43he98d",
          'time': DateTime.now(),
          'fname': "Eric C",
          'headline': "Student",
          'f1': "I like cars",
          'f2': "I like planes",
          'f3': "I like boats",
          'profileURL':
              "https://firebasestorage.googleapis.com/v0/b/btiui-7097a.appspot.com/o/user_images%2F6DJZ2fotXWPkGsm9zBKXq3t6Q?alt=media&token=a1dd8aaa-dd8a-461d-b37e-2bbbe5fb7eb4",
          'hidden': false,
          'blocked': []
        });
      }
      Globals.changeLastUserLoc(UserLoc(uid, null, point.data, fname, headline,
          f1, f2, f3, hidden, profileURL, "", "", blocked));
      Globals.changeLastRun(DateTime.now());
      return await locationCollection.doc(userId).set({
        'position': point.data,
        'name': userId,
        'time': DateTime.now(),
        'fname': fname,
        'headline': headline,
        'f1': f1,
        'f2': f2,
        'f3': f3,
        'profileURL': profileURL,
        'hidden': hidden,
        'blocked': blocked
      });
    }
  }

  // Determine location permission
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        print("Location error!");
        Fluttertoast.showToast(
            msg:
                "Your location services seem to be disabled! For the best experience please enable it in settings then log back in.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 20,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return Position(
            longitude: -71,
            latitude: 44,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
      }
    } catch (e) {
      print(e);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print("Location error!");
        Fluttertoast.showToast(
            msg:
                "Your location services seem to be disabled! For the best experience please enable it in settings then log back in.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 20,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return Position(
            longitude: -71,
            latitude: 44,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("Location error!");
      Fluttertoast.showToast(
          msg:
              "Your location services seem to be disabled! For the best experience please enable it in settings then log back in.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 20,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return Position(
          longitude: -71,
          latitude: 44,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var c = await Geolocator.getCurrentPosition();
    return c;
  }

  Future getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Stream<List<Waves>> get wavesGet async* {
    final User? user = await AuthService().getCurrentUser();
    String loggedinuid = user?.uid ?? " ";
    print(loggedinuid);

    var stream1 = wavesUserAttrCollection
        .where("receiver_uid", isEqualTo: loggedinuid)
        .snapshots();

    var stream2 = stream1.map((event) {
      return event.docs.map((doc) {
        return Waves(
            doc.get('uid') ?? " ",
            doc.get('fname') ?? " ",
            doc.get('headline') ?? " ",
            doc.get('f1') ?? " ",
            doc.get('f2') ?? " ",
            doc.get('f3') ?? " ",
            doc.get('imageID') ?? " ",
            doc.get('lastActive') ?? " ",
            doc.get('message') ?? " ",
            doc.get('time') ?? " ",
            doc.get('seen'),
            doc.id);
      }).toList();
    });

    yield* stream2;
  }

  // Query nearby users - working
  Stream<List<UserLoc>> get nearbyUsers async* {
    Position? pos;
    //pos = await Geolocator.getLastKnownPosition();
    //pos = await determinePosition();

    //GeoFirePoint point =
    //    geo.point(latitude: pos.latitude, longitude: pos.longitude);

    //GeoFirePoint point = geo.point(
    //    latitude: Globals.getCurLoc(), longitude: Globals.getCurLoc());

    // 1000 ft radius in km -> reduce radius
    double radius = 10;
    String field = 'position';

    //var stream = geo
    //    .collection(collectionRef: locationCollection)
    //    .within(center: point, radius: radius, field: field, strictMode: true)
    //    .map(LocationsFromSnapshot);

    var hourAgo =
        Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 1)));
    var stream1 = locationCollection
        .where("time", isGreaterThanOrEqualTo: hourAgo)
        .snapshots();
    var stream2 = stream1.map((event) {
      return event.docs.map((doc) {
        return UserLoc(
            doc.get('name') ?? " ",
            doc.get('time') ?? " ",
            doc.get('position') ?? " ",
            doc.get('fname') ?? " ",
            doc.get('headline') ?? " ",
            doc.get('f1') ?? " ",
            doc.get('f2') ?? " ",
            doc.get('f3') ?? " ",
            doc.get('hidden') ?? " ",
            doc.get('profileURL') ?? " ",
            "",
            "",
            doc.get('blocked'));
      }).toList();
    });

    yield* stream2;
  }

  // Format list of user locations - not working
  List<UserLoc> LocationsFromSnapshot(List<DocumentSnapshot> snapshot) {
    return snapshot.map((doc) {
      return UserLoc(
          doc.get('name') ?? " ",
          doc.get('time') ?? " ",
          doc.get('position') ?? " ",
          doc.get('fname') ?? " ",
          doc.get('headline') ?? " ",
          doc.get('f1') ?? " ",
          doc.get('f2') ?? " ",
          doc.get('f3') ?? " ",
          doc.get('hidden') ?? " ",
          doc.get('profileURL') ?? " ",
          "",
          "",
          doc.get('blocked'));
    }).toList();
  }
}
