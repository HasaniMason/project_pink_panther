import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Firebase/Firebase/ClientFirebase.dart';

import '../mainScreen.dart';
import 'Introductory Screen.dart';





class SplashScreen extends StatefulWidget {
 final Client client;

 SplashScreen({required this.client});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ClientFirebase clientFirebase = ClientFirebase();


  @override
  void initState(){
    super.initState();

    Future.delayed(Duration(seconds: 3),(){
      changeToScreen();
    });


  }

  void changeToScreen()async{
    if (FirebaseAuth.instance.currentUser == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IntroductoryScreen(clientFirebase: clientFirebase)));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(client: widget.client)));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.black,
      child: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png'),
    );
  }
}
