import 'package:flutter/material.dart';
import 'package:top_tier/Screens/Settings%20Screens/Account%20Details%20Screen/Main%20Account%20Screen.dart';
import 'package:top_tier/main.dart';
import '../../Custom Data/Clients.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

import '../../Firebase/ClientFirebase/ClientFirebase.dart';
import '../../Widgets/UserCircleWithInitials.dart';
import 'Book Appointments/OpeningAppointmentsScreen.dart';
import 'Shop Screens/OpeningRetailScreen.dart';

class RetailSelectionScreen extends StatefulWidget {
  Client client;

  RetailSelectionScreen({super.key, required this.client});

  @override
  State<RetailSelectionScreen> createState() => _RetailSelectionScreenState();
}

class _RetailSelectionScreenState extends State<RetailSelectionScreen> {
  ClientFirebase clientFirebase = ClientFirebase();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _key,
        drawer: drawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {},
              child: UserCircleWithInitials(client: widget.client)),
          actions: [
            IconButton(
                onPressed: () async {
                  _key.currentState!.openDrawer();

                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 5,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                  width: MediaQuery.of(context).size.width,
                ),
                Hero(
                    tag: 'Hero',
                    child: Image.asset(
                        'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png'))
              ]),
            ),
            Flexible(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OpeningAppointmentScreen(client: widget.client)));
                },
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    'Book Appointment',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ]),
              ),
            ),
            Flexible(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OpeningRetailScreen(client: widget.client)));
                },
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    'Shop',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.black),
                  )
                ]),
              ),
            ),
            Flexible(
              flex: 3,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                ),
                Text(
                  'Apparel',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      //elevation: 5,
      //shadowColor: Colors.pink,
      backgroundColor: Colors.black,
        child: ListView(
      children: [
        DrawerHeader(
          child: UserCircleWithInitials(
            client: widget.client,
            maxRadius: 40,
            textSize: 65,
          ),
        ),

        //Notifications slider
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Notifications",
                style: TextStyle(color: Theme
                    .of(context)
                    .colorScheme
                    .primary),
              ),
              Switch(
                  activeColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  value: widget.client.notificationsOn,
                  onChanged: (value) {
                    setState(() {
                      //notifications = !notifications;
                    });
                  })
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainAccountScreen(client: widget.client)));
            },
            child: Text(
              "Account Page",
              style: TextStyle(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
            ),
          ),
        ),

        Divider(),

        TextButton(onPressed: () async {
          await clientFirebase.signOut();

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
        }, child: const Text('Sign Out'))
      ],
    ));
  }
}
