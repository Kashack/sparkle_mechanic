import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../business/constants/constant.dart';
import '../../business/database_helper.dart';
import '../components/my_dropdownbutton.dart';
import '../components/text_form_field.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? fullName;
  DateTime? dob;
  String? email;
  String? phoneNumber;
  String? gender;
  List genderList = ['--Select--', 'Male', 'Female'];
  bool editProfile = false;

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _databaseHelper = DatabaseHelper(context);
    final Stream<DocumentSnapshot> userStream =
    _firestore.collection('mechanics').doc(_auth.currentUser!.uid).snapshots();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      editProfile = !editProfile;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: MyConstant.mainColor,
                  ))
            ],
            title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
          ),
          body: Form(
            key: _formKey,
            child: StreamBuilder<DocumentSnapshot>(
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
                  if(getSnap.containsKey('dateOfBirth')){
                    dob = snapshot.data!.get('dateOfBirth').toDate();
                  }
                  fullName = snapshot.data!.get('fullname');

                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MyTextField(
                              labelText: 'First Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Full Name';
                                }
                                return null;
                              },
                              enable: editProfile,
                              initialText: fullName,
                              onchanged: (value) => fullName = value,
                              inputType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MyTextField(
                              labelText: 'email',
                              enable: false,
                              initialText: snapshot.data!.get('email'),
                              inputType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MyTextField(
                              labelText: 'Date of Birth',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your DOB';
                                }
                                return null;
                              },
                              enable: editProfile,
                              initialText: getSnap.containsKey('dateOfBirth')
                                  ? '${dob!.year}/${dob!.month}/${dob!.day}'
                                  : dob == null
                                  ? ""
                                  : '${dob!.year}/${dob!.month}/${dob!.day}',
                              suffix_icon: IconButton(
                                onPressed: () async {
                                  if (editProfile) {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime.now(),
                                    );
                                    if (newDate == null) return;
                                    setState(() {
                                      dob = newDate;
                                    });
                                  }
                                },
                                icon: Icon(Icons.calendar_month_outlined,
                                    color: editProfile
                                        ? MyConstant.mainColor
                                        : Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MyDropdownButton(
                              enable: editProfile,
                              itemList: genderList,

                              labelText: Text('Gender'),
                              callback: (value) => gender = genderList[value],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MyTextField(
                              labelText: 'Phone Number',
                              enable: editProfile,
                              textLimit: 11,
                              initialText: getSnap.containsKey('phoneNumber')
                                  ? snapshot.data!.get('phoneNumber')
                                  : "",
                              onchanged: (value) => phoneNumber = value,
                              inputType: TextInputType.number,
                            ),
                          ),
                          Visibility(
                            visible: editProfile,
                            maintainSize: false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        editProfile == false;
                                      });
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        bool check = await _databaseHelper
                                            .updateUserProfile(
                                            fullname: fullName!,
                                            DateOfBirth: dob!,
                                            phoneNumber: phoneNumber!,
                                            Gender: gender!);
                                        setState(() {
                                          _isLoading = check;
                                        });
                                      }
                                    },
                                    color: MyConstant.mainColor,
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                }),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black12,
            ),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
