

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io' show Platform;



class PushNotifications{

  final  _firebaseMessaging = FirebaseMessaging.instance;


  Future<String> initNotifications() async{
    //await _firebaseMessaging.requestPermission();

    var iosToken;
    var fcMToken;
   //
   //  fcMToken = await _firebaseMessaging.getToken();
   //  print(fcMToken);
   //  return fcMToken;

    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getAPNSToken();


   // fcMToken = await _firebaseMessaging.getToken();

    print(token);

    return token??"";
   // // if ios, get ios specific token
   //  if(Platform.isIOS){
   //     iosToken = await FirebaseMessaging.instance.getAPNSToken();
   //
   //
   //      Future.delayed(const Duration(milliseconds: 500));
   //
   //      print(iosToken);
   //      return iosToken;
   //
   //  }else{    //else get android specific token
   //     fcMToken = await _firebaseMessaging.getToken();
   //     return fcMToken;
   //  }
   //



  }

  Future getDeviceToken() async{

  }

}