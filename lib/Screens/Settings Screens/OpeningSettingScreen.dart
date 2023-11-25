import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/AdminRoles/AdminShop/SeeAllOrdersScreen.dart';
import 'package:top_tier/Custom%20Data/Constants/Constants.dart';
import 'package:top_tier/Screens/Settings%20Screens/Account%20Details%20Screen/Main%20Account%20Screen.dart';
import 'package:top_tier/Screens/Settings%20Screens/AddressSettingsScreen.dart';
import 'package:top_tier/Screens/Settings%20Screens/Previous%20Orders/PreviousOrdersScreen.dart';
import '../../Firebase/Firebase/ClientFirebase.dart';
import '/Custom%20Data/Clients.dart';
import 'package:url_launcher/url_launcher.dart';

class OpeningSettingScreen extends StatefulWidget {
  Client client;

  OpeningSettingScreen({super.key, required this.client});

  @override
  State<OpeningSettingScreen> createState() => _OpeningSettingScreenState();
}

class _OpeningSettingScreenState extends State<OpeningSettingScreen> {
  ClientFirebase clientFirebase = ClientFirebase();
  final Uri uri = Uri.parse(
      'https://app.termly.io/document/privacy-policy/9f2498be-c08d-48dc-bca4-e45466e50191');

  final Uri disclaimerUri = Uri.parse(
      'https://app.termly.io/document/disclaimer/4348799a-cbfa-45fc-a387-62a4a1c04af0');

  final Uri returnPolicyUri = Uri.parse(
      'https://app.termly.io/document/refund-policy/a898715e-31ff-4903-ad9f-d8cf5f991844');

  setUp() async {
    widget.client = await clientFirebase.getClient();
  }

  bool toggle = true;

  Future _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch url');
    }
  }

  @override
  void initState() {
    super.initState();

    //setUp();

    // DocumentReference totalReference =
    // FirebaseFirestore.instance.collection('clients').doc(widget.client.id);
    //
    // totalReference.snapshots().listen((event) {
    //   if(mounted)
    //   setState(() {
    //     widget.client.notificationsOn = event.get('notificationsOn');
    //   });
    // });

    setState(() {
      toggle = widget.client.notificationsOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            appBar: AppBar(
              //to remove back navigation button
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 16),
                    child: Text('Settings',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),

                  //list of settings item
                  settingsItems(context),

                  // SizedBox(
                  //   height: 150,
                  // ),
                ],
              ),
            ),
          );
        });
  }

  SafeArea CITexQuote(BuildContext context) {
    ConstantDatabase constantDatabase = ConstantDatabase();

    return SafeArea(
        child: Column(
      children: [
        Center(
            child: Container(
                height: 150,
                child: Image.asset(
                    'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png'))),
        Text('Version: ${constantDatabase.version}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).primaryColor)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Powered by',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('lib/Images/CITex_noBack copy.png')),
          ],
        )
      ],
    ));
  }

  Padding settingsItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 42),
      child: Column(
        children: [
          //Notification toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notifications",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              Switch(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: toggle,
                  onChanged: (value) async {
                    print(widget.client.notificationsOn);
                    //await clientFirebase.toggleNotification(widget.client);
                    setState(() {
                      widget.client.notificationsOn = value;
                      toggle = value;
                    });

                    await clientFirebase.toggleNotification(widget.client);
                  })
            ],
          ),

          //Account Details button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainAccountScreen(
                                client: widget.client,
                              )));
                },
                child: Text(
                  'Account Details',
                  style:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainAccountScreen(
                                  client: widget.client,
                                )));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),

          //Address info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressSettingsScreen(
                                  client: widget.client,
                                )));
                  },
                  child: Text(
                    'Address',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressSettingsScreen(
                                  client: widget.client,
                                )));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),

          //if admin, go to all order screen
          widget.client.admin
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAllOrdersScreen()));
                        },
                        child: Text(
                          'All Orders',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAllOrdersScreen()));
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ))
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviousOrdersScreen(
                                        client: widget.client,
                                      )));
                        },
                        child: Text(
                          'Past Orders',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviousOrdersScreen(
                                        client: widget.client,
                                      )));
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ))
                  ],
                ),

          //Private Policy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    _launchUrl(uri);
                  },
                  child: Text(
                    'Privacy Policy',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
              IconButton(
                  onPressed: () {
                    _launchUrl(uri);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    _launchUrl(returnPolicyUri);
                  },
                  child: Text(
                    'Return Policy',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
              IconButton(
                  onPressed: () {
                    _launchUrl(returnPolicyUri);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),

          //Disclaimer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    _launchUrl(disclaimerUri);
                  },
                  child: Text(
                    'Disclaimer',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
              IconButton(
                  onPressed: () {
                    _launchUrl(disclaimerUri);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),

          CITexQuote(context)
        ],
      ),
    );
  }
}
