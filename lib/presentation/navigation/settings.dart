import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../business/constants/constant.dart';
import '../../business/database_helper.dart';
import '../authentication/sign_in.dart';
import '../settings_screens/user_profile.dart';

class Settings extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper(context);
    final Stream<DocumentSnapshot> userStream =
    _firestore.collection('mechanics').doc(_auth.currentUser!.uid).snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: const Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return Center(child: CircularProgressIndicator());
            }
            Map getSnap = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Stack(
                          children: [
                            getSnap.containsKey('profilePicUrl') == false
                                ? CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.camera_alt_outlined),
                            )
                                : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        snapshot.data!.get('profilePicUrl'),
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFF555FD2)),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                              bottom: 5,
                              right: 2,
                            )
                          ],
                        ),
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            await dbHelper.updateProfilePic(File(pickedFile.path));
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data!.get('fullname'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(snapshot.data!.get('email')),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(),
                          ));
                    },
                    leading:
                    Icon(Icons.account_circle, color: Color(0xFF555FD2)),
                    title: Text('Profile',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review_outlined, color: Color(0xFF555FD2)),
                    title: Text('My Reviews',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Color(0xFF555FD2)),
                    title: Text('Change Password',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (context) {
                          return Container(
                            height: 170,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Are sure you want to log out?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: MyConstant.mainColor),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide(
                                                  color: MyConstant.mainColor,
                                                  width: 2
                                              )
                                          )
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => SignInPage()),
                                                (route) => false);
                                      },
                                      child: Text(
                                        'Yes, Logout',
                                        style: TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          backgroundColor: MyConstant.mainColor
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.redAccent,
                    ),
                    title: Text('Logout',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
