import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/BookingEvents.dart';


class AppointmentsAdminScreen extends StatefulWidget {
  const AppointmentsAdminScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsAdminScreen> createState() =>
      _AppointmentsAdminScreenState();
}

class _AppointmentsAdminScreenState extends State<AppointmentsAdminScreen> {

  Stream<QuerySnapshot> eventStream = FirebaseFirestore.instance.collection(
      'bookEvents').snapshots();
  List<DocumentSnapshot> eventList = [];

  setUp() async {

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            appBar: AppBar(
              title: Container(
                  height: 100,
                  child: Image.asset(
                      'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
              automaticallyImplyLeading: false,
              actions: [],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context); //to go page to previous page
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme
                              .of(context)
                              .primaryColor,
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Admin - Appointments',
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                color: Theme
                                    .of(context)
                                    .primaryColor)),
                      ),
                    ),
                  ],
                ),


                Expanded(
                  child: StreamBuilder(
                      stream: eventStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        //if there is an error
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        //while it connects
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        eventList = snapshot.data!.docs;

                        //listview
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              BookingEvent thisBookingEvent = BookingEvent(
                                  startTime: (eventList[index]['startTime']as Timestamp).toDate(),
                                  day: (eventList[index]['day']as Timestamp).toDate(),
                                  firstName: eventList[index]['firstName'],
                                  lastName: eventList[index]['lastName'],
                                  id: eventList[index]['id'],
                                  complete: eventList[index]['complete'],
                                  approved: eventList[index]['approved'],
                                  lashType: eventList[index]['lashType'],
                                  phoneNumber: eventList[index]['phoneNumber'],
                                  clientId: eventList[index]['clientId'],
                                  clientEmail: eventList[index]['clientEmail']);

                              return Text("${thisBookingEvent.firstName}");

                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox();
                            },
                            itemCount: eventList.length);
                      }),
                ),
              ],
            ),
          );
        }
    );
  }
}
