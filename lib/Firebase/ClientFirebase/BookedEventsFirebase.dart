import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/BookingEvents.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Screens/Retail%20Screens/Book%20Appointments/OpeningAppointmentsScreen.dart';
import 'package:uuid/uuid.dart';


class BookedEventsFirebase {

  //add appointment
  bookEvent(Client client, BookingEvent bookingEvent) {
    //get random number for id
    var uuid = const Uuid();
    var id = uuid.v4();

    bookingEvent.id = id;

    final docRef = FirebaseFirestore.instance
        .collection('bookEvents')
        .withConverter(
        fromFirestore: BookingEvent.fromFireStore,
        toFirestore: (BookingEvent bookingEvent, options) =>
            bookingEvent.toFireStore())
        .doc(id);

    docRef.set(bookingEvent);
  }


  //get all appointments for user
  Future<List<Meeting>>getBookEventsForClient(Client client, BuildContext context) async {
    //create blank list
    List<Meeting> meetings = <Meeting>[];

    //get documents in firebase that belongs to client
    final docRef = FirebaseFirestore.instance
        .collection('bookEvents')
        .withConverter(
        fromFirestore: BookingEvent.fromFireStore,
        toFirestore: (BookingEvent bookingEvent, options) =>
            bookingEvent.toFireStore()).where('clientId', isEqualTo: client.id);

     final docSnap = await docRef.get().then((value) =>
    {

       for( var docSnapshot in value.docs){ //iterate through all documents

         print("Just entered: ${docSnapshot.data().startTime}"),

        meetings.add(Meeting("Lash Appointment for ${client.firstName} ${client.lastName}. Phone: ${client.phoneNumber}", docSnapshot
            .data()
            .startTime, docSnapshot
            .data()
            .startTime, Theme
            .of(context)
            .primaryColor, false)),

        print(docSnapshot.data().startTime),


      }
    });

    print(meetings.length);
    return(meetings);
  }
}