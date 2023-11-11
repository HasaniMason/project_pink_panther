import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/Enums/SignInStatus.dart';
import 'package:top_tier/Screens/mainScreen.dart';

import '../../Firebase/Firebase/ClientFirebase.dart';
import '../../Widgets/TextFieldWidgets.dart';
import 'SignUpScreen.dart';

class IntroductoryScreen extends StatefulWidget {
  ClientFirebase clientFirebase;

  IntroductoryScreen({super.key, required this.clientFirebase});

  @override
  State<IntroductoryScreen> createState() => _IntroductoryScreenState();
}

class _IntroductoryScreenState extends State<IntroductoryScreen> {
  static const List<String> images = [
    'lib/Images/TestImages/lashes2.jpeg',
    'lib/Images/TestImages/lashes1.jpeg'
  ];

  static const List<String> images2 = [
    'lib/Images/TestImages/lashes1.jpeg',
    'lib/Images/TestImages/lashes2.jpeg',
  ];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  SignInStatus? signInStatus = SignInStatus.userNotFound;


  @override
  void initState() {
    super.initState();



    //setStatusBarColor();   //method to change status bar
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary, //change background to secondary color - black
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context)
        //       .colorScheme
        //       .secondary, //change the appbar to black
        // ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: topGraphic(),
              ),

              //to create space between graphics
              // const SizedBox(
              //   height: 50,
              // ),

              textFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topGraphic() {
    return Column(
      children: [
        Container(
            height: 400,
            child: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png',fit: BoxFit.fitHeight,),
        ),

        //Image Carousel
        // FanCarouselImageSlider(
        //   imagesLink: images,
        //   isAssets: true,
        //   sliderHeight: 100,
        //   userCanDrag: false,
        //   isClickable: false,
        //   showIndicator: false,
        //   sliderDuration: const Duration(milliseconds: 300),
        // ),
        // FanCarouselImageSlider(
        //   imagesLink: images2,
        //   isAssets: true,
        //   sliderHeight: 100,
        //   userCanDrag: false,
        //   isClickable: false,
        //   showIndicator: false,
        //   sliderDuration: const Duration(milliseconds: 300),
        // )
      ],
    );
  }

  Widget textFields() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        //decoration for container that contains text fields and buttons
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          children: [
            //Text field for email
            TextFieldWithSuffixIcon(
              suffixIcon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).primaryColor,
              ),
              hintText: 'Email',
              textEditingController: emailController,
              passwordText: false,
            ),

            //Text field for password
            TextFieldWithSuffixIcon(
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).primaryColor,
              ),
              hintText: 'Password',
              textEditingController: passwordController,
              passwordText: true,
            ),



            //Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () async {

                 signInStatus = await widget.clientFirebase.signIn(emailController.text, passwordController.text);

                 print('Sign in Status: $signInStatus');

                 signInStatus != SignInStatus.success ?
                 errorDialog(context, signInStatus!): null;


                 {Client client = await widget.clientFirebase.getClient();

                 if(client.firstName != 'Not Signed In')
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)));}

              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),

            //visible divider
            const Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Divider(
                color: Colors.grey,
              ),
            ),

            //Button to sign in with google
            alternateSignInButtons(),



            //Sign Up Button
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  //show sign up screen with modal

                  showCupertinoModalSheet(
                    context: context,
                    builder: (context) => const SignUpScreen(),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget alternateSignInButtons() {
    return Column(
            children: [

              //google button
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 24, right: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.white),
                  onPressed: () async {
                    Client client = await widget.clientFirebase.signInWithGoogle();


                    if(client.firstName != 'Not Signed In')
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('lib/Images/GoogleIcon.png'),
                        ),
                      ),
                      Text(
                        "Login with Google",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
              ),

              //apple button
              // Padding(
              //   padding: const EdgeInsets.only(right: 24.0, left: 24),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         shape: const StadiumBorder(),
              //         backgroundColor: Colors.white),
              //     onPressed: () async {
              //       await widget.clientFirebase.signInWithApple();
              //
              //
              //       // if(client.firstName != 'Not Signed In')
              //       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)));
              //
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: SizedBox(
              //             width: 30,
              //             height: 30,
              //             child: Image.asset('lib/Images/appleLogoo.png'),
              //           ),
              //         ),
              //         Text(
              //           "Login with Apple",
              //           style: TextStyle(color: Theme.of(context).primaryColor),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          );
  }

  AwesomeDialog errorDialog(BuildContext context, SignInStatus status){

    String errorMessage = 'Error';
    if(signInStatus == SignInStatus.invalidCred){
      errorMessage = 'Invalid Credentials. If you created an account using Google or Apple, sign in using the options below.';
    }
    if(signInStatus == SignInStatus.invalidEmail){
      errorMessage = 'Invalid email. If you created an account using Google or Apple, sign in using the options below.';
    }
    if(signInStatus == SignInStatus.wrongPassword){
      errorMessage = 'Wrong password. If you created an account using Google or Apple, sign in using the options below.';
    }
    if(signInStatus == SignInStatus.userNotFound){
      errorMessage = 'User not found. If you created an account using Google or Apple, sign in using the options below.';
    }
    if(signInStatus == SignInStatus.disabled){
      errorMessage = 'Account disabled. Contact admin if you think this is a mistake.';
    }

    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: errorMessage,
    )..show();
  }
}
