import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparkle_mechanic/presentation/record_appointment/track_order.dart';
import '../../business/constants/constant.dart';

class UpcomingAppointment extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // che
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> upcomingStream = _firestore
        .collection('appointments')
        .where('appointment_status',
            whereIn: ['Upcoming', 'Ongoing', 'Confirmed'])
        .orderBy('bookDate')
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
        stream: upcomingStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Container();
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty == false) {
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    DateTime bookDate = data['bookDate'].toDate();
                    String formattedDate = DateFormat.MMMEd().format(bookDate);
                    String formattedTime = DateFormat.jm().format(bookDate);

                    if (bookDate.isBefore(DateTime.now()) || bookDate == DateTime.now()) {
                      try {
                        _firestore
                            .collection('appointments')
                            .doc(document.id)
                            .update({'appointment_status': 'Ongoing'});
                      } on FirebaseException catch (e) {
                        if (e.code == "network-request-failed") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Network failed'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${e.code}')));
                        }
                      }
                    }
                    return GestureDetector(
                      onTap: () {
                        if(data['appointment_status'] == 'Ongoing'){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackOrder(bookingId: document.id,),
                              ));
                        }
                      },
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${data['serviceType']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        // Text('Booking ID: ${document.id}',style: TextStyle(fontSize: 16),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: data['appointment_status'] ==
                                                  'Upcoming'
                                                  ? Colors.green
                                                  : Colors.yellow)),
                                      child: Text(
                                    data['appointment_status'],
                                    style: TextStyle(color: data['appointment_status'] ==
                                        'Upcoming'
                                        ? Colors.green
                                        : Colors.yellow),
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        'Car: ${data['carName']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                          ' ${formattedDate} | ${formattedTime}'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Cancel Appointment'),
                                          titleTextStyle: const TextStyle(
                                              color: Colors.red),
                                          content: const Text(
                                              'Are u sure u want Cancel the appointment'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              child: const Text('Back'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                try {
                                                  _firestore
                                                      .collection(
                                                          'appointments')
                                                      .doc(document.id)
                                                      .update({
                                                    'appointment_status':
                                                        'Cancelled'
                                                  }).then((value) {
                                                    Navigator.pop(context);
                                                  });
                                                } on FirebaseException catch (e) {
                                                  if (e.code ==
                                                      "network-request-failed") {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Network failed'),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                '${e.code}')));
                                                  }
                                                }
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: MyConstant.mainColor)),
                                  child: Text(
                                    'Cancel Appointment',
                                    style:
                                        TextStyle(color: MyConstant.mainColor),
                                  ),
                                ),
                                // MaterialButton(
                                //   child: const Text('Re - schedule',
                                //       style: TextStyle(color: Colors.white)),
                                //   onPressed: () {
                                //     print(document.id);
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) =>
                                //               GeneralCarServices(),
                                //         ));
                                //   },
                                //   color: MyConstant.mainColor,
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
                  .toList()
                  .cast(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              const Text(
                'You don\'t have any available bookings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}
