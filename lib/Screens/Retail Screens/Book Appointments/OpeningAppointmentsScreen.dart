import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

import '../../../Custom Data/BookingEvents.dart';
import '../../../Widgets/UserCircleWithInitials.dart';
import 'package:calendar_view/calendar_view.dart';
import '../../../Custom Data/Clients.dart';
import 'AddEventScreen.dart';


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


  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Appointments",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            centerTitle: true,
            //to center title/logo
            backgroundColor: Colors.white,
            leading:  IconButton(
                onPressed: () {Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back)),

            //user circle avatar

            actions: [
            UserCircleWithInitials(
            client: widget.client,
          ),
            ],
          ),
          body:

              ///replace this with another calendar
            MonthView(
              minMonth: DateTime(DateTime.now().year,DateTime.now().month),
              onCellTap: (events,date){
                addEventsModal(date,events);
              },
            )

        ),

    );
  }



  addEventsModal(DateTime selectedDate, List<CalendarEventData> eventData){

    // CalendarEventData newEvent = CalendarEventData(title: 'Book', date: selectedDate);
    // eventController.add(newEvent);

   return showCupertinoModalSheet(context: context, builder: (context)=>AddEventScreen(selectedDate: selectedDate,eventController: eventController, eventData: eventData,));
  }


}
