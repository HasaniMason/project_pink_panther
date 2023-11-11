import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/BookingEvents.dart';

import '../../Custom Data/Items.dart';
import '../../Firebase/Firebase/BookedEventsFirebase.dart';

class AppointmentsAdminScreen extends StatefulWidget {
  const AppointmentsAdminScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsAdminScreen> createState() =>
      _AppointmentsAdminScreenState();
}

class _AppointmentsAdminScreenState extends State<AppointmentsAdminScreen> {
  Stream<QuerySnapshot> eventStream = FirebaseFirestore.instance
      .collection('bookEvents')
      .orderBy('startTime', descending: false)
      .snapshots();
  List<DocumentSnapshot> eventList = [];

  BookedEventsFirebase bookedEventsFirebase = BookedEventsFirebase();

  setUp() async {}

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
              actions: [

              ],
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
                          color: Theme.of(context).primaryColor,
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Admin - Appointments',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        eventList = snapshot.data!.docs;

                        //listview
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              BookingEvent thisBookingEvent = BookingEvent(
                                  startTime: (eventList[index]['startTime']
                                          as Timestamp)
                                      .toDate(),
                                  day: (eventList[index]['day'] as Timestamp)
                                      .toDate(),
                                  firstName: eventList[index]['firstName'],
                                  lastName: eventList[index]['lastName'],
                                  id: eventList[index]['id'],
                                  complete: eventList[index]['complete'],
                                  approved: eventList[index]['approved'],
                                  lashType: eventList[index]['lashType'],
                                  phoneNumber: eventList[index]['phoneNumber'],
                                  clientId: eventList[index]['clientId'],
                                  clientEmail: eventList[index]['clientEmail'],
                              description: eventList[index]['description']);

                              return GestureDetector(
                                onTap: (){
                                  ///create popup screen for options
                                  dialogBox(thisBookingEvent);
                                },
                                child: BookingWidget(
                                  event: thisBookingEvent,
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox();
                            },
                            itemCount: eventList.length);
                      }),
                ),
              ],
            ),
          );
        });
  }

  dialogBox(BookingEvent bookingEvent){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Choose an Option'),
        actions: [
          TextButton(onPressed: (){

            bookedEventsFirebase.approveAppointment(bookingEvent);
            Navigator.pop(context);
          }, child: Text("Approve")),
          TextButton(onPressed: (){
            bookedEventsFirebase.deleteAppointment(bookingEvent);
            Navigator.pop(context);
          }, child: Text("Delete")),
          TextButton(onPressed: (){
            bookedEventsFirebase.completeAppointment(bookingEvent);

            Navigator.pop(context);
          }, child: Text("Complete & Delete"))

        ],
      );
    });
  }

}

class BookingWidget extends StatefulWidget {
  final BookingEvent event;

  BookingWidget({required this.event});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.secondary, blurRadius: 5)
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${widget.event.firstName} ${widget.event.lastName}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        'Date: ${widget.event.startTime.month}/${widget.event.startTime.day}/${widget.event.startTime.year}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        'Time: ${widget.event.startTime.hour}:${widget.event.startTime.minute}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Approval: ${widget.event.approved}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    widget.event.complete
                        ? Text(
                            'Status: Complete',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          )
                        : Text(
                            'Status: Incomplete',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                    Text(
                      'Number: ${widget.event.phoneNumber}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                )
              ],
            ),

            Text(
              'Email: ${widget.event.clientEmail}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),

            Text(
              'Services : ${widget.event.description}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),

          ],
        ),
      ),
    );
  }
}
