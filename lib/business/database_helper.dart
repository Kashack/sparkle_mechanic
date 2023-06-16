import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var context;

  DatabaseHelper(BuildContext context) {
    this.context = context;
  }

  Future updateProfilePic(File picPath) async {
    final filePath = 'profile_${_auth.currentUser!.uid}';
    try {
      await _storage.ref(filePath).putFile(picPath).then((value) {
        value.ref.getDownloadURL().then((valueUrl) {
          _firestore.collection('mechanics').doc(_auth.currentUser!.uid).update({
            'profilePicUrl': valueUrl,
          });
        }, onError: (e) => print("Error getting document: $e"));
      });
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
  }

  Future<bool> updateUserProfile({
    required String fullname,
    required DateTime DateOfBirth,
    required String phoneNumber,
    required String Gender,
  }) async {
    try {
      await _firestore.collection('mechanics').doc(_auth.currentUser!.uid).update({
        'fullname': fullname,
        'dateOfBirth': DateOfBirth,
        'gender': Gender,
        'phoneNumber': phoneNumber
      });
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }

    return false;
  }
}
