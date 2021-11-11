import 'package:cloud_firestore/cloud_firestore.dart';

class UserLoc {
  final String uid;
  final Timestamp? time;
  final Map? position;

  UserLoc(this.uid, this.time, this.position);
}
