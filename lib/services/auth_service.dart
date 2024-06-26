import 'package:btiui/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:btiui/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  UserAtt? userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserAtt(user.uid, user.email);
  }

  Stream<UserAtt?>? get user {
    return _firebaseAuth.authStateChanges().map(userFromFirebase);
  }

  Future<UserAtt?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message ?? "No Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print(e.message);
    }
  }

  Future<UserAtt?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message ?? "No Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print(e.message);
    }
  }

  Future<auth.User?> getCurrentUser() async {
    final auth.User? user = await auth.FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    // Issue clearing cache
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();

    return await _firebaseAuth.signOut();
  }
}
