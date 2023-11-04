import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:top_tier/Screens/Retail%20Screens/Book%20Appointments/BookingInformationScreen.dart';
import '../../../Widgets/UserCircleWithInitials.dart';
import 'package:calendar_view/calendar_view.dart';
import '../../../Custom Data/Clients.dart';
import 'AddEventScreen.dart';
import 'package:flutter_timeline_calendar/timeline/dictionaries/en.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OpeningAppointmentScreen extends StatefulWidget {
  Client client;

  OpeningAppointmentScreen({super.key, required this.client});

  @override
  State<OpeningAppointmentScreen> createState() =>
      _OpeningAppointmentScreenState();
}

class _OpeningAppointmentScreenState extends State<OpeningAppointmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  EventController eventController = EventController();
  CalendarController calendarController = CalendarController();

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Logo Here",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            centerTitle: true,
            //to center title/logo
            backgroundColor: Colors.white,
            leading: UserCircleWithInitials(
              client: widget.client,
            ),

            //user circle avatar

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
                        color: Theme.of(context).primaryColor,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Appointments',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SfCalendar(
                    controller: calendarController,
                    view: CalendarView.month,
                    monthViewSettings: const MonthViewSettings(
                        showAgenda: true,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment),
                    dataSource: MeetingDataSource(_getDataSource()),
                    //data source to add events to calendar
                    timeSlotViewSettings: const TimeSlotViewSettings(
                        startHour: 8,
                        endHour: 16,
                        nonWorkingDays: <int>[DateTime.sunday]),

                    onTap: calendarTapped,
                  ),
                ),
              )
            ],
          )),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    print("Tapped: ${details.appointments}");

    if (details.appointments!.isEmpty) {
      addEventsModal(details.date!);
    } else {
      bookedEventModal(details, widget.client, calendarController);
    }
  }

  bookedEventModal(CalendarTapDetails details, Client client,
      CalendarController calendarController) {
    return showCupertinoModalSheet(
        context: context,
        builder: (context) => BookingInformationScreen(
            calendarController: calendarController,
            details: details,
            client: client));
  }

  addEventsModal(DateTime selectedDate) {
    // CalendarEventData newEvent = CalendarEventData(title: 'Book', date: selectedDate);
    // eventController.add(newEvent);

    return showCupertinoModalSheet(
        context: context,
        builder: (context) => AddEventScreen(
              selectedDate: selectedDate,
              calendarController: calendarController,
            ));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
