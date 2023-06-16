import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sparkle_mechanic/presentation/authentication/sign_in.dart';

import '../../business/authentication/authentication.dart';
import '../../business/constants/constant.dart';
import '../components/custom_button.dart';
import '../components/my_dropdownbutton.dart';
import '../components/text_form_field.dart';
class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? password;
  String? confirmPassword;
  String? specialization;
  bool _isLoading = false;
  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Authentication(context);
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Text('Welcome!',style: TextStyle(
                          color: MyConstant.mainColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Full Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Full Name';
                            }
                            return null;
                          },
                          onchanged: (value) => name = value,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onchanged: (value) => email = value,
                          inputType: TextInputType.emailAddress,
                        ),
                      ),
                      MyDropdownButton(
                          itemList: SpecializationList,
                          callback: (value) => specialization = SpecializationList[value]
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onchanged: (value) => password = value,
                          suffix_icon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                            icon: _isObsecure == true
                                ? Icon(
                              Icons.visibility_off,
                              color: Colors.black,
                            )
                                : Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          isObscureText: _isObsecure,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Confirm Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value != password){
                              return 'Password does not match';
                            }
                            return null;
                          },
                          onchanged: (value) => confirmPassword = value,
                          suffix_icon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObsecureConfirm = !_isObsecureConfirm;
                              });
                            },
                            icon: _isObsecureConfirm == true
                                ? Icon(
                              Icons.visibility_off,
                              color: Colors.black,
                            )
                                : Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          isObscureText: _isObsecureConfirm,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              bool check = await authentication.CreateAnAccount(
                                  email: email!, password: password!,fullname: name!, specialiazed: specialization!);
                              setState(() {
                                _isLoading = check;
                              });
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                                (route) => false,
                          );
                        },
                        child: Text(
                          'Already have an account? - Sign In',
                          style: TextStyle(
                            color: MyConstant.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

List SpecializationList = [
  '--Select--',
  'auto paint technician',
  'car wash attendant',
  'Automotive Engineer',
];