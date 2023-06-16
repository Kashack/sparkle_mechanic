import 'package:flutter/material.dart';

class MyConstant{
  static const Color mainColor = Color(0xFF304FFE);

}
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,

);

final kMessageContainerDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  border:  Border.all(
    color: MyConstant.mainColor
  )
);