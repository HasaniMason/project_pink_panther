import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '/Custom%20Data/Clients.dart';




class BookingInformationScreen extends StatefulWidget {
  CalendarController calendarController;
  CalendarTapDetails details;
  Client client;

  BookingInformationScreen({super.key, required this.calendarController, required this.details, required this.client});

  @override
  State<BookingInformationScreen> createState() => _BookingInformationScreenState();
}

class _BookingInformationScreenState extends State<BookingInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'My Appointment',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
