import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:top_tier/Firebase/Push%20Notifications/pushNotification.dart';
import 'package:top_tier/Screens/Introductory%20Screens/Introductory%20Screen.dart';
import 'package:top_tier/Screens/Introductory%20Screens/SplashScreen.dart';
import 'package:top_tier/Screens/mainScreen.dart';
import 'Custom%20Data/Clients.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

import 'Firebase/Firebase/ClientFirebase.dart';
import 'Screens/Retail Screens/RetailSelectionScreen.dart';
import 'Screens/Social%20Screens/MainSocialScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/Settings Screens/OpeningSettingScreen.dart';
import 'firebase_options.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);



  Stripe.publishableKey = "pk_test_51OBePwJn90tCGP7svuXgXYtbIoU8lEalnfWLBysRzw9r549ViXBhlEPXpNhqcvj0hPeWZX4pxIv6r2znZHUDzbzF00giw7XWWY";
  Stripe.merchantIdentifier = 'Top Tier';
  await Stripe.instance.applySettings();

  await dotenv.load(fileName: "lib/Keys/.env");

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(statusBarColor: Colors.white),
  // );

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

    //_child = RetailSelectionScreen(client: client);


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

      print('${FirebaseAuth.instance.currentUser!.uid}');

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


    //
    // if (FirebaseAuth.instance.currentUser == null){
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IntroductoryScreen(clientFirebase: clientFirebase)));
    // }else{
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)));
    //
    // }


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


  // Widget runSplashScreen(){
  //   Future.delayed(Duration(seconds: 3),(){
  //     if (FirebaseAuth.instance.currentUser == null){
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IntroductoryScreen(clientFirebase: clientFirebase)));
  //     }else{
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)));
  //
  //     }
  //   });
  // }

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
              child: SplashScreen(client: client,),
                    //Open source code to display splash screen
                    // AnimatedSplashScreen(
                    //     splash: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png',fit: BoxFit.fill),
                    //     backgroundColor: Colors.black,
                    //     duration: 3000,
                    //     nextScreen: IntroductoryScreen(
                    //       clientFirebase: clientFirebase,
                    //     ),
                    //     //nextScreen: MainScreen(client: clients,),
                    //     splashTransition: SplashTransition.fadeTransition,
                    //     pageTransitionType: PageTransitionType.fade,
                    //   )
                    // : AnimatedSplashScreen(
                    //     splash: Container(child: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png',fit: BoxFit.fitHeight,)),
                    //     backgroundColor: Colors.black,
                    //     duration: 3000,
                    //     nextScreen: MainScreen(
                    //       client: client,
                    //     ),
                    //     //nextScreen: MainScreen(client: clients,),
                    //     splashTransition: SplashTransition.fadeTransition,
                    //     pageTransitionType: PageTransitionType.fade,
                    //   ),
            );
          },
        )

        //const IntroductoryScreen()

        //OpeningRetailScreen(client: clients,) //go to intro screen
        );
  }

  //Screen to show when signed in

}
