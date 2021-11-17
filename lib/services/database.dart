import 'package:btiui/models/user_model.dart';
import 'package:btiui/models/location_model.dart';
import 'package:btiui/models/nearby_user_model_db.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/user_model_db.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'globals.dart';

class DatabaseService {
  final CollectionReference userAttrCollection =
      FirebaseFirestore.instance.collection('userAttr');

  // Edit Profile - Working
  Future updateUserData(String fname, String headline, String f1, String f2,
      String f3, String profileURL, bool hidden) async {
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
      );
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
    );
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
  Future updateLocation(String fname, String headline, String f1, String f2,
      String f3, String profileURL, bool hidden, bool first, String uid) async {
    Position? pos;
    DateTime lr;
    lr = Globals.getLastRun();
    String userId = uid;

    if (userId == "" ||
        (DateTime.now().difference(lr) < Duration(seconds: 59) &&
            first == false)) {
      print("Not sent");
      return null;
    } else {
      pos = await _determinePosition();
      GeoFirePoint point =
          geo.point(latitude: pos.latitude, longitude: pos.longitude);
      print("Sent");
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
        'hidden': hidden
      });
    }
  }

  // Determine location permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // // Test if location services are enabled.
    // try {
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    // } catch (e) {
    //   print(e);
    // }

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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var c = await Geolocator.getCurrentPosition();
    return c;
  }

  // Query nearby users - working
  Stream<List<UserLoc>> get nearbyUsers async* {
    Position? pos;
    //pos = await Geolocator.getLastKnownPosition();
    pos = await _determinePosition();

    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);

    // 1000 ft radius in km
    double radius = 10;
    String field = 'position';

    var stream = geo
        .collection(collectionRef: locationCollection)
        .within(center: point, radius: radius, field: field, strictMode: true)
        .map(LocationsFromSnapshot);
    yield* stream;
  }

  // Format list of user locations - working
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
          "");
    }).toList();
  }
}
