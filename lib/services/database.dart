import 'package:btiui/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model_db.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userAttrCollection =
      FirebaseFirestore.instance.collection('userAttr');

  Future updateUserData(String fname, String headline, String f1, String f2,
      String f3, bool hidden) async {
    return await userAttrCollection.doc(uid).set({
      'fname': fname,
      'headline': headline,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'hidden': hidden,
    });
  }


  Future<DocumentSnapshot> getUserData() async {
    return await userAttrCollection.doc(uid).get();
  }

  // Get own user info
  List<UserAttDB> _userAttDBFromSnapshot(QuerySnapshot snapshot) {
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

  Stream<List<UserAttDB>> get UserAttDBs {
    //return userAttrCollection
    //    .where('fname', isEqualTo: "Eric")
    //    .snapshots()
    //    .map(_userAttDBFromSnapshot);
    return userAttrCollection
        .where('__name__', isEqualTo: uid)
        .snapshots()
        .map(_userAttDBFromSnapshot);
  }
}
