import 'package:flutter/material.dart';
import 'package:top_tier/AdminRoles/AdminShop/SeeAllOrdersScreen.dart';
import 'package:top_tier/Screens/Settings%20Screens/Account%20Details%20Screen/Main%20Account%20Screen.dart';
import 'package:top_tier/Screens/Settings%20Screens/Previous%20Orders/PreviousOrdersScreen.dart';
import 'package:top_tier/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Custom Data/Clients.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

import '../../Firebase/Firebase/ClientFirebase.dart';
import '../../Firebase/Push Notifications/pushNotification.dart';
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
  final Uri uri = Uri.parse(
      'https://app.termly.io/document/privacy-policy/9f2498be-c08d-48dc-bca4-e45466e50191');

  //function to launch url
  Future _launchUrl() async {
    if (!await launchUrl(this.uri)) {
      throw Exception('Could not launch url');
    }
  }

  setUp() async {
    widget.client = await clientFirebase.getClient();

    setState(() {});

    //get permission for push notification and then retrieve unique tokens


    //assign
    clientFirebase.assignMessagingToken(widget.client);
  }

  @override
  void initState() {
    super.initState();

    setUp();

    //PushNotifications().initNotifications();


  }

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
              child: widget.client.firstName == 'Not Signed In'
                  ? CircularProgressIndicator()
                  : UserCircleWithInitials(client: widget.client)),
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
              flex: 4,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      'Shop',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.black),
                    ),
                  )
                ]),
              ),
            ),
            // Flexible(
            //   flex: 3,
            //   child: Stack(alignment: AlignmentDirectional.center, children: [
            //     Container(
            //       color: Colors.black,
            //       width: MediaQuery.of(context).size.width,
            //     ),
            //     Text(
            //       'Apparel',
            //       style: Theme.of(context)
            //           .textTheme
            //           .displayMedium!
            //           .copyWith(color: Theme.of(context).primaryColor),
            //     )
            //   ]),
            // ),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainAccountScreen(client: widget.client)));
                },
                child: Text(
                  "Account Page",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),

            !widget.client.admin?
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PreviousOrdersScreen(client: widget.client)));
                  },
                  child: Text("Past Orders",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                )):
                //if admin
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllOrdersScreen()));
                  },
                  child: Text("Orders",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                )),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _launchUrl();
                  },
                  child: Text("Privacy Policy",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                )),

            Divider(),

            TextButton(
                onPressed: () async {
                  await clientFirebase.signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (route) => false);
                },
                child: const Text('Sign Out'))
          ],
        ));
  }
}
