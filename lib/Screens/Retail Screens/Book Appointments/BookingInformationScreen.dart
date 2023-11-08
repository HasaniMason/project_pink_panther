import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:top_tier/Custom%20Data/BookingEvents.dart';
import '/Custom%20Data/Clients.dart';

class BookingInformationScreen extends StatefulWidget {
  final CalendarController calendarController;
  final CalendarTapDetails details;
  final Client client;

  const BookingInformationScreen(
      {super.key,
      required this.calendarController,
      required this.details,
      required this.client});

  @override
  State<BookingInformationScreen> createState() =>
      _BookingInformationScreenState();
}

class _BookingInformationScreenState extends State<BookingInformationScreen> {
  late Stream<QuerySnapshot> bookingStream;
  List<DocumentSnapshot> bookingList = [];

  setUp() async {

    bookingList = [];
    //get appointment belong to client for that date
    bookingStream = FirebaseFirestore.instance
        .collection('bookEvents')
        //.where('clientId', isEqualTo: widget.client.id)
        //.where('day', isEqualTo: DateUtils.dateOnly(widget.details.date!))
        .snapshots();

    print(bookingStream.length);
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            //appBar: AppBar(),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).primaryColor,
                            blurRadius: 15)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      topInfo(context),

                      EventList(),
                      //Buttons()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Column topInfo(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'My Appointments',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          'Lashes',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
        Text(
          "Selected Date: ${widget.calendarController.selectedDate!.month}/${widget.calendarController.selectedDate!.day}/${widget.calendarController.selectedDate!.year}",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }

  Column Buttons() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {}, child: const Text("Request to reschedule")),
        ElevatedButton(
            onPressed: () {}, child: const Text("Delete appointment"))
      ],
    );
  }

  Widget EventList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 300,
        child: StreamBuilder(
          stream: bookingStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //if there is an error
            if (snapshot.hasError) {
              return const Text('Error');
            }
            //while it connects
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            bookingList = snapshot.data!.docs;

            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  BookingEvent thisBookingEvent = BookingEvent(
                      startTime: (bookingList[index]['startTime'] as Timestamp).toDate(),
                      day: (bookingList[index]['day'] as Timestamp).toDate(),
                      firstName: bookingList[index]['firstName'],
                      lastName: bookingList[index]['lastName'],
                      id: bookingList[index]['id'],
                      complete: bookingList[index]['complete'],
                      approved: bookingList[index]['approved'],
                      lashType: bookingList[index]['lashType'],
                      phoneNumber: bookingList[index]['phoneNumber'],
                      clientId: bookingList[index]['clientId'],
                      clientEmail: bookingList[index]['clientEmail']);

                  print("Booking date: ${DateUtils.dateOnly(thisBookingEvent.startTime)}- Selected date:${DateUtils.dateOnly(widget.calendarController.selectedDate!)}");
                  //if dates are same from as selected date

                    return EventWidget(
                       // key: ObjectKey(thisBookingEvent),
                        bookingEvent: thisBookingEvent,
                    client:  widget.client,
                    calendarDetails: widget.details,);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemCount: bookingList.length);
          },
        ),
      ),
    );
  }
}


class EventWidget extends StatefulWidget {
  final BookingEvent bookingEvent;
  final Client client;
  final CalendarTapDetails calendarDetails;
  
   EventWidget({super.key, required this.bookingEvent, required this.client, required this.calendarDetails});
  

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return
      DateUtils.dateOnly(widget.calendarDetails.date!) == DateUtils.dateOnly(widget.bookingEvent.startTime) ?
      Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6
            )
          ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.bookingEvent.firstName} ${widget.bookingEvent.lastName}',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),),
                  Text("${widget.bookingEvent.startTime}"),
                  Text("Time -${widget.bookingEvent.startTime.hour}:${widget.bookingEvent.startTime.minute}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor))
                ],
              ),
            ),

            Column(
              children: [
                widget.bookingEvent.approved ?
                    Text('Appointment has been approved',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor)):
                Text('Appointment has not been approved',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor))

              ],
            )
          ],
        ),
      ),
    ):
          const SizedBox();
  }
}

