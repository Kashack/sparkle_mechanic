import 'package:flutter/material.dart';

import '../../business/constants/constant.dart';

class CustomButton extends StatelessWidget {
  String buttonText;
  Function() onPressed;

  CustomButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
            color: MyConstant.mainColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
