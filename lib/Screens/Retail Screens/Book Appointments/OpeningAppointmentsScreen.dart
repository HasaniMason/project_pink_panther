import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:top_tier/AdminRoles/AdminAppointments/AppointmentsAdminScreen.dart';
import 'package:top_tier/Screens/Retail%20Screens/Book%20Appointments/BookingInformationScreen.dart';
import '../../../AdminRoles/AdminShop/ShopAdminScreen.dart';
import '../../../Firebase/Firebase/BookedEventsFirebase.dart';
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


  CalendarController calendarController = CalendarController();
  BookedEventsFirebase bookedEventsFirebase = BookedEventsFirebase();
  List<Meeting> meetings = <Meeting>[];

  //use future function to get events
  setUp()async{
    meetings = await bookedEventsFirebase.getBookEventsForClient(widget.client, context);
  }

  //function to return meetings list to calendar
  List<Meeting> _getDataSource(){
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setUp(),
      //initialData: const Text('Loading...'),
      builder: (BuildContext context, AsyncSnapshot text){
      return Scaffold(
          appBar: AppBar(

            actions: [
              if (widget.client.admin)
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AppointmentsAdminScreen()));
                    },
                    icon: Icon(Icons.admin_panel_settings_outlined)),
            ],

            title: Hero(
              tag: 'Hero',
              child: SizedBox(
                height: 100,
                  child: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
            ),
            centerTitle: true,
            //to center title/logo
            backgroundColor: Colors.white,
            leading: UserCircleWithInitials(
              client: widget.client,
            ),

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
                    minDate: DateTime.now(),
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

                    onLongPress: null,
                    onTap: calendarTapped,
                    showDatePickerButton: true,
                  ),
                ),
              )
            ],
          ));
  }
    );
  }

  Future<void> calendarTapped(CalendarTapDetails details) async {
    print("Tapped: ${details.appointments}");



    if (details.appointments!.isEmpty) {
     await addEventsModal(details.date!,details);
    } else {
      bookedEventModal(details, widget.client, calendarController);
    }
  }

  bookedEventModal(CalendarTapDetails details, Client client,
      CalendarController calendarController) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => BookingInformationScreen(
            calendarController: calendarController,
            details: details,
            client: client)).then((value) => {  //to update page after closing
              setState((){
                calendarController.dispose();
              })
    });
  }

  addEventsModal(DateTime selectedDate, CalendarTapDetails details) {

    return showCupertinoModalSheet(
        context: context,
        builder: (context) => AddEventScreen(
              selectedDate: selectedDate,
              calendarController: calendarController,
          client: widget.client,
          details: details,
            )).then((value) => {    //to update page after closing
              setState((){
                calendarController.dispose();

              })
    });
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
