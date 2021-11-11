import 'package:btiui/models/user_model.dart';
import 'package:btiui/models/location_model.dart';
import 'package:btiui/models/nearby_user_model_db.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model_db.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

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
  Future updateLocation() async {
    var pos = await _determinePosition();
    print("lat:");
    print(pos.latitude);
    print("lon:");
    print(pos.longitude);
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? "";
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    //GeoFirePoint point = geo.point(latitude: 43.139273, longitude: -70.953941);
    if (userId == "") {
      return null;
    } else {
      print("new location");
      return await locationCollection.doc(userId).set(
          {'position': point.data, 'name': userId, 'time': DateTime.now()});
    }
  }

  // Determine location permission
  Future<Position> _determinePosition() async {
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Query nearby users - working
  Stream<List<UserLoc>> get nearbyUsers async* {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";

    // Problematic line below
    //var pos = await location.getLocation();
    var pos = await _determinePosition();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    //GeoFirePoint point = geo.point(latitude: 43.139273, longitude: -70.953941);

    // 500 ft radius in km
    double radius = 0.1524;
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
      );
    }).toList();
  }

  // Stream list of nearby users - working
  Stream<List<NearUserAttDB>> allNearbyUsersAttr(
      Stream<List<UserLoc>> usersIDStream) async* {
    List<NearUserAttDB> attrList = [];
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    DateTime now = DateTime.now();
    DateTime nowminus30 = DateTime.now().subtract(const Duration(minutes: 900));
    var pos = await _determinePosition();

    await for (List<UserLoc> users in usersIDStream) {
      //print(users.length);
      users.forEach((element) async {
        DateTime ago = element.time!.toDate();
        if (element.uid != userId && ago.isAfter(nowminus30)) {
          final Stream<UserAttDB> userAttrStream = userAttrCollection
              .doc(element.uid)
              .snapshots()
              .map(userAttDBFromSnapshotNL);
          await for (UserAttDB item in userAttrStream) {
            if (item.hidden == false) {
              int minago = now.difference(ago).inMinutes;
              final lastActive = minago.toString();

              int distanceInFeet = ((Geolocator.distanceBetween(
                          pos.latitude,
                          pos.longitude,
                          element.position?['geopoint'].latitude,
                          element.position?['geopoint'].longitude)) *
                      3.281)
                  .round();

              final distance = distanceInFeet.toString();
              attrList.add(NearUserAttDB(
                element.uid,
                lastActive,
                distance,
                item.fname,
                item.headline,
                item.f1,
                item.f2,
                item.f3,
                false,
                item.profileURL,
              ));
            }
          }
        }
      });
      print(attrList.length);
      yield attrList;
    }
  }
}
