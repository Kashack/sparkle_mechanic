import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../business/constants/constant.dart';

class PastAppointment extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> upcomingStream = _firestore
        .collection('appointments')
        .where('appointment_status', whereIn: ['Cancelled', 'Completed'])
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
                    return Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      padding: EdgeInsets.all(8),
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
                                  child: Container(
                                    height: 100,
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(data['carPicUrl']),
                                        fit: BoxFit.fill
                                      )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${data['serviceType']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text('Booking ID: ${document.id}'),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: data['appointment_status'] ==
                                                        'Cancelled'
                                                        ? Colors.red
                                                        : Colors.blue)),
                                            child: Text(
                                              data['appointment_status'],
                                              style: TextStyle(
                                                  color: data['appointment_status'] ==
                                                      'Cancelled'
                                                      ? Colors.red
                                                      : Colors.blue),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
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
