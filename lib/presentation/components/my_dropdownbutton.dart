import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  List itemList;
  Function callback;
  bool enable;
  var initialValue;
  Widget? labelText;

  MyDropdownButton(
      {required this.itemList,
      this.labelText,
      this.initialValue,
      this.enable = true,
      required this.callback});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  var dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.initialValue == null
        ? widget.initialValue
        : widget.itemList.indexOf(widget.itemList.first);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(

      validator: (value) {
        if (value == 0) {
          return 'Please select a value';
        }
      },
      isExpanded: true,
      style: TextStyle(
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        fillColor: Colors.grey.shade200,
        filled: true,
        label: widget.labelText,
      ),
      value: dropdownValue,
      items: widget.itemList.map((value) {
        return DropdownMenuItem(
          child: Text(value),
          value: widget.itemList.indexOf(value),
        );
      }).toList(),
      onChanged: !widget.enable ? null : (value) {
        setState(() {
          dropdownValue = value;
          widget.callback(value);
        });
      },
    );
  }
}
