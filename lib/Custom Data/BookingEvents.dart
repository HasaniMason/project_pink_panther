import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingEvent {
  DateTime startTime;
  DateTime day;
  String firstName;
  String lastName;
  String id;
  bool complete; //is event completed
  bool approved; //has event been approved by admin
  String lashType;//type of lashes
  String phoneNumber;
  String clientId;
  String clientEmail;

  BookingEvent({
    required this.startTime,
    required this.day,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.complete,
    required this.approved,
    required this.lashType,
    required this.phoneNumber,
    required this.clientId,
    required this.clientEmail
});


  factory BookingEvent.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options){
    final data = snapshot.data();
    return BookingEvent(
        startTime: (data?['startTime']as Timestamp).toDate(),
        day: (data?['day'] as Timestamp).toDate(),
        firstName: data?['firstName'],
        lastName: data?['lastName'],
        id: data?['id'],
        complete: data?['complete'],
        approved: data?['approved'],
        lashType: data?['lashType'],
        phoneNumber: data?['phoneNumber'],
      clientId: data?['clientId'],
      clientEmail: data?['clientEmail']
        );
  }

  Map<String, dynamic> toFireStore(){
    return{
      'startTime':startTime,
      'day':day,
      'firstName':firstName,
      'lastName':lastName,
      'id': id,
      'complete':complete,
      'approved':approved,
      'lashType': lashType,
      'phoneNumber': phoneNumber,
      'clientId':clientId,
      'clientEmail':clientEmail

    };
  }

}
