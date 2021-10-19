import 'package:btiui/models/user_model.dart';
import 'package:btiui/models/location_model.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model_db.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class DatabaseService {
  final CollectionReference userAttrCollection =
      FirebaseFirestore.instance.collection('userAttr');

  Future updateUserData(String fname, String headline, String f1, String f2,
      String f3, bool hidden) async {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    return await userAttrCollection.doc(userId).set({
      'fname': fname,
      'headline': headline,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'hidden': hidden,
    });
  }

  // Get own user info
  List<UserAttDB> userAttDBFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserAttDB(
        doc.get('fname') ?? " ",
        doc.get('headline') ?? " ",
        doc.get('f1') ?? " ",
        doc.get('f2') ?? " ",
        doc.get('f3') ?? " ",
      );
    }).toList();
  }

  //Stream<List<UserAttDB>> get UserAttDBs2 async* {
  //  final User? user = await AuthService().getCurrentUser();
  //  String userId = user?.uid ?? " ";
  //  //print(userId);
  //  yield* userAttrCollection
  //      .where('__name__', isEqualTo: userId)
  //      .snapshots()
  //      .map(userAttDBFromSnapshot);
  //}

  UserAttDB userAttDBFromSnapshotNL(DocumentSnapshot snapshot) {
    var doc = snapshot;
    return UserAttDB(
      doc.get('fname') ?? " ",
      doc.get('headline') ?? " ",
      doc.get('f1') ?? " ",
      doc.get('f2') ?? " ",
      doc.get('f3') ?? " ",
    );
  }

  Stream<UserAttDB> get UserAttDBs3 async* {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    var document =
        userAttrCollection.doc(userId).snapshots().map(userAttDBFromSnapshotNL);
    yield* document;
  }

  // Location update and stream for new users

  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');
  Geoflutterfire geo = Geoflutterfire();
  Location location = Location();

  Future updateLocation() async {
    var pos = await location.getLocation();
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? "Not found";
    GeoFirePoint point =
        geo.point(latitude: pos.latitude ?? 0, longitude: pos.longitude ?? 0);
    if (userId == "") {
      return null;
    } else {
      print("new location");
      return await locationCollection.doc(userId).set(
          {'position': point.data, 'name': userId, 'time': DateTime.now()});
    }
  }

  Stream<List<UserLoc>> get nearbyUsers async* {
    final User? user = await AuthService().getCurrentUser();
    String userId = user?.uid ?? " ";
    var pos = await location.getLocation();
    print(pos);
    GeoFirePoint point =
        geo.point(latitude: pos.latitude ?? 0, longitude: pos.longitude ?? 0);
    double radius = 0.1524;
    String field = 'position';
    var stream = geo
        .collection(collectionRef: locationCollection)
        .within(center: point, radius: radius, field: field, strictMode: true)
        .map(LocationsFromSnapshot);
    //stream.listen((userList) {
    //  userList.forEach((element) {
    //    print(element.get('__name__'));
    //  });
    //});

    yield* stream;
  }

  List<UserLoc> LocationsFromSnapshot(List<DocumentSnapshot> snapshot) {
    return snapshot.map((doc) {
      return UserLoc(
        doc.get('name') ?? " ",
        doc.get('time') ?? " ",
      );
    }).toList();
  }
}
