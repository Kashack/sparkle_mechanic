import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../presentation/navigation/nav_page.dart';
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var context;

  Authentication(BuildContext context) {
    this.context = context;
  }

  Future<bool> SigninAuthentication(
      {required String email, required String password}) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationPages(),
          ),
          (route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
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

  Future<bool> CreateAnAccount(
      {required String fullname,
      required String email,
        required String specialiazed,
      required String password}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _firestore.collection('mechanics').doc(_auth.currentUser!.uid).set({
          'fullname': fullname,
          'email': email,
          'Specialized': specialiazed,
        }).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationPages(),
            ),
            (route) => false,
          );
        }).catchError((e) {
          if (e.code == "network-request-failed") {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Network error')));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${e.code}')));
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Network error')));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email already in use')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
    return false;
  }
}
