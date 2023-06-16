import 'package:flutter/material.dart';

import '../../business/constants/constant.dart';
import '../record_appointment/past.dart';
import '../record_appointment/upcoming.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('My Appointment',style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            indicatorColor: MyConstant.mainColor,
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: 'UPCOMING',
              ),
              Tab(
                text: 'PAST',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UpcomingAppointment(),
            PastAppointment(),
          ],
        ),
      ),
    );
  }
}
