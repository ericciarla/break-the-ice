import 'package:cloud_firestore/cloud_firestore.dart';

class UserLoc {
  final String uid;
  final Timestamp? time;
  final Map? position;
  final String? fname;
  final String? headline;
  final String? f1;
  final String? f2;
  final String? f3;
  final bool? hidden;
  final String? profileURL;
  String? lastActive;
  String? distance;

  UserLoc(
      this.uid,
      this.time,
      this.position,
      this.fname,
      this.headline,
      this.f1,
      this.f2,
      this.f3,
      this.hidden,
      this.profileURL,
      this.lastActive,
      this.distance);
}
