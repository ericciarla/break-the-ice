import 'package:cloud_firestore/cloud_firestore.dart';

class Waves {
  final String uid;
  final String? fname;
  final String? headline;
  final String? f1;
  final String? f2;
  final String? f3;
  final String? profileURL;
  final String? lastActive;
  final String? message;
  final Timestamp? time;
  final bool seen;
  final String? notif_id;

  Waves(
      this.uid,
      this.fname,
      this.headline,
      this.f1,
      this.f2,
      this.f3,
      this.profileURL,
      this.lastActive,
      this.message,
      this.time,
      this.seen,
      this.notif_id);
}
