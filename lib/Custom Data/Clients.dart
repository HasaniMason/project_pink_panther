import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String firstName; //client firstname
  String lastName; //client lastname
  String email; //client email
  DateTime birthday; //client birthday
  String phoneNumber;


  String id; //unique id for client's account
  String token; //unique token to use for push notifications
  bool activeAccount; //if account is active
  bool admin; //if account has admin status or not

  bool notificationsOn;

  String? nextBooking;


  //specify if these variable are required or not. If not must declare variable using '?' to the right of variable type
  Client({required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthday,
    required this.id,
    required this.token,
    required this.activeAccount,
    required this.admin,
  required this.phoneNumber,
  required this.notificationsOn,
  this.nextBooking});


  factory Client.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options){
    final data = snapshot.data();
    return Client(
        firstName: data?['firstName'],
        lastName: data?['lastName'],
        email: data?['email'],
        birthday: data?['birthday'].toDate(),
        id: data?['id'],
        token: data?['token'],
        activeAccount: data?['activeAccount'],
        admin: data?['admin'],
    phoneNumber: data?['phoneNumber'],
    notificationsOn: data?['notifications'],
    nextBooking: data?['nextBooking']);
  }

  Map<String, dynamic> toFireStore(){
    return{
      'firstName':firstName,
      'lastName':lastName,
      'email':email,
      'birthday': birthday,
      'id': id,
      'token': token,
      'activeAccount': activeAccount,
      'admin': admin,
      'phoneNumber': phoneNumber,
      'notificationsOn': notificationsOn,
      'nextBooking':nextBooking
    };
  }


}
