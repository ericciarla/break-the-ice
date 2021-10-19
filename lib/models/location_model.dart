import 'package:cloud_firestore/cloud_firestore.dart';

class UserLoc {
  final String uid;
  final Timestamp? time;

  UserLoc(this.uid, this.time);
}
