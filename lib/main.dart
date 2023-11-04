import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_tier/Firebase/ClientFirebase/ClientFirebase.dart';
import 'package:top_tier/Screens/Introductory%20Screens/Introductory%20Screen.dart';
import 'package:top_tier/Screens/mainScreen.dart';
import 'Custom%20Data/Clients.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

import 'Screens/Retail%20Screens/Shop%20Screens/RetailSelectionScreen.dart';
import 'Screens/Social%20Screens/MainSocialScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/Settings Screens/OpeningSettingScreen.dart';
import 'firebase_options.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _child;

  ClientFirebase clientFirebase = ClientFirebase();

  Client client = Client(
      firstName: 'Not Signed In',
      lastName: "",
      email: '',
      birthday: DateTime.now(),
      id: '',
      token: '',
      activeAccount: false,
      admin: false,
      phoneNumber: '',
  notificationsOn: true);

  @override
  void initState() {
    super.initState();

    _child = RetailSelectionScreen(client: client);

    ///change this to separate screen
  }

  Future<void> getClient() async {
    //if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection('clients')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
              fromFirestore: Client.fromFireStore,
              toFirestore: (Client client, options) => client.toFireStore());

      final docSnap = await docRef.get(); // get data

      client = docSnap.data()!; //return data

      print("${client.firstName}");
    } else {
      //return empty client variable
      client = Client(
          firstName: 'Not Signed In',
          lastName: "",
          email: '',
          birthday: DateTime.now(),
          id: '',
          token: '',
          activeAccount: false,
          admin: false,
          phoneNumber: '',
          notificationsOn: true);
    }
  }

  //google fonts
  //**Font 1 Possibilities
  //Mr Dafoe
  //Homemade Apple
  //Tangerine
  //Parisienne
  //Playball

  //**Font 2 Possibilities
  //Sriracha
  //

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,

          //text theme throughout app
          textTheme: TextTheme(
            bodySmall: GoogleFonts.sriracha(
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            bodyMedium: GoogleFonts.sriracha(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            displaySmall: GoogleFonts.mrDafoe(
                textStyle: const TextStyle(
                  fontSize: 36,
                )),
            displayMedium: GoogleFonts.mrDafoe(
                textStyle: const TextStyle(
              fontSize: 48,
            )),
            displayLarge: GoogleFonts.mrDafoe(
                textStyle: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
          ),

          //Default color scheme throughout app
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xffef6def),
              primary: const Color(0xffef6def),
              secondary: Colors.black),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: getClient(),
          initialData: const Text("Loading"),
          builder: (BuildContext context, AsyncSnapshot text) {
            return WillPopScope(
                onWillPop: () async => false,
                child: FirebaseAuth.instance.currentUser == null
                    ?
                    //Open source code to display splash screen
                    AnimatedSplashScreen(
                        splash: Text(
                          'Logo Here',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: const Color(0xffef6def)),
                        ),
                        backgroundColor: Colors.black,
                        duration: 3000,
                        nextScreen: IntroductoryScreen(
                          clientFirebase: clientFirebase,
                        ),
                        //nextScreen: MainScreen(client: clients,),
                        splashTransition: SplashTransition.fadeTransition,
                        pageTransitionType: PageTransitionType.fade,
                      )
                    : AnimatedSplashScreen(
                        splash: Text(
                          'Logo Here',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: const Color(0xffef6def)),
                        ),
                        backgroundColor: Colors.black,
                        duration: 3000,
                        nextScreen: MainScreen(
                          client: client,
                        ),
                        //nextScreen: MainScreen(client: clients,),
                        splashTransition: SplashTransition.fadeTransition,
                        pageTransitionType: PageTransitionType.fade,
                      ),
            );
          },
        )

        //const IntroductoryScreen()

        //OpeningRetailScreen(client: clients,) //go to intro screen
        );
  }

  //Screen to show when signed in
  Scaffold mainScreen() {
    return Scaffold(
      extendBody: true,
      body: _child,
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.store,
              backgroundColor: Colors.grey,
              extras: {'label': 'Store'}),
          FluidNavBarIcon(
              icon: Icons.people,
              backgroundColor: Colors.grey,
              extras: {'label': 'News'}),
          FluidNavBarIcon(
              icon: Icons.settings,
              backgroundColor: Colors.grey,
              extras: {'label': 'Settings'})
        ],
        onChange: _handleNavigationChange,
        style: const FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.black,
            iconSelectedForegroundColor: Color(0xffef6def),
            barBackgroundColor: Color(0xffef6def)),
        scaleFactor: 1.5,
        defaultIndex: 0,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!['label'],
          child: item,
        ),
      ),
    );
  }

  //method to handle change when a new icon is selected in the nav bar... changes screens
  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = RetailSelectionScreen(client: client);
          break;
        case 1:
          _child = MainSocialScreen(
            client: client,
          );
          break;
        case 2:
          _child = OpeningSettingScreen(client: client);
          break;
      }

      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
