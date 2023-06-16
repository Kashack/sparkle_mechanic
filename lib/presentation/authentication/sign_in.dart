import 'package:flutter/material.dart';
import 'package:sparkle_mechanic/presentation/authentication/sign_up.dart';

import '../../business/authentication/authentication.dart';
import '../../business/constants/constant.dart';
import '../components/custom_button.dart';
import '../components/text_form_field.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _isLoading = false;
  bool _isObsecure = true;

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Sign In',style: TextStyle(color: MyConstant.mainColor,fontWeight: FontWeight.bold,fontSize: 24)),
                    SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        labelText: 'Email....',
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget your password?',
                            style: TextStyle(
                              color: MyConstant.mainColor,
                            ),
                          )
                      ),
                    ),
                    CustomButton(
                      buttonText: 'Sign In',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          bool check = await authentication.SigninAuthentication(
                              email: email!, password: password!);
                          setState(() {
                            _isLoading = check;
                          });
                        }

                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                              (route) => false,
                        );
                      },
                      child: Text(
                        'Click here to create an account',
                        style: TextStyle(
                            color: MyConstant.mainColor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
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
