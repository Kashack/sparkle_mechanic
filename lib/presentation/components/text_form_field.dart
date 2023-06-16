import 'package:flutter/material.dart';

import '../../business/constants/constant.dart';

class MyTextField extends StatelessWidget {
  String? labelText;
  String? hintText;
  Widget? prefix_icon;
  Widget? suffix_icon;
  bool isObscureText;
  String? initialText;
  int? textLimit;
  bool enable;
  String? Function(String?)? validator;
  TextInputType? inputType;
  Function(String)? onchanged;
  int? maxLines;
  bool readOnly;

  MyTextField({
    required this.labelText,
    this.inputType,
    this.textLimit,
    this.prefix_icon,
    this.suffix_icon,
    this.hintText,
    this.readOnly = false,
    this.enable = true,
    this.initialText,
    this.isObscureText = false,
    this.validator,
    this.maxLines = 1,
    this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      onChanged: onchanged,
      maxLength: textLimit,
      validator: validator,
      maxLines: maxLines,
      initialValue: initialText,
      readOnly: readOnly,
      enabled: enable,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyConstant.mainColor,width: 1)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyConstant.mainColor,width: 1)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyConstant.mainColor,width: 1)
        ),
        prefixIcon: prefix_icon,
        hintText: hintText,
        label: Text(
          labelText!,
          style: TextStyle(
            color: enable ? MyConstant.mainColor : Colors.grey,
          ),
        ),
        alignLabelWithHint: true,
        suffixIcon: suffix_icon,
      ),
      obscureText: isObscureText,
    );
  }
}
