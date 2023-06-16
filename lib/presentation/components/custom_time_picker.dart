import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../business/constants/constant.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function callback;

  const CustomTimePicker(
      {Key? key, required this.callback, required this.selectedDate})
      : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int tag = 0;
  DateTime now = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  List<TimeOfDay> timeList = [];

  generateTimeList() {
    if (widget.selectedDate.day == now.day) {
      startTime = TimeOfDay(hour: now.hour, minute: now.minute);
      if (startTime.hour < 9) {
        startTime = const TimeOfDay(hour: 9, minute: 0);
      } else if (startTime.minute < 30) {
        startTime = TimeOfDay(hour: now.hour, minute: 30);
      } else if (startTime.minute > 30) {
        startTime = TimeOfDay(hour: now.hour + 1, minute: 0);
      }
    }
    for (int i = 0; i <= 20; i++) {
      timeList.add(startTime);
      if (startTime.hour == 17) {
        break;
      }
      if (startTime.minute == 30) {
        startTime = TimeOfDay(hour: startTime.hour + 1, minute: 00);
      } else {
        startTime =
            TimeOfDay(hour: startTime.hour, minute: startTime.minute + 30);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    generateTimeList();
  }

  @override
  Widget build(BuildContext context) {
    widget.callback(timeList[tag]);
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
        crossAxisSpacing: 2
      ),
      // scrollDirection: Axis.vertical,
      children: List.generate(
        timeList.length,
            (index) => ChoiceChip(
          label: Text(DateFormat.jm().format(DateTime(now.year, now.month,
              now.day, timeList[index].hour, timeList[index].minute))),
          selected: tag == index,
          backgroundColor: Colors.white,
          selectedColor: MyConstant.mainColor,
          labelStyle: tag == index ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black) ,
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          shape: RoundedRectangleBorder(
              side: tag == index ? BorderSide.none: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10)
          ),
          onSelected: (selected) {
            setState(() {
              tag = (selected ? index : null)!;
            });
          },
        ),
      ),
    );
  }
}
