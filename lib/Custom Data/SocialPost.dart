import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Custom%20Data/Clients.dart';

class SocialPost {
  String description;
  String postID;

 String firstName;
 String lastName;
 String clientId;
  String? pic;

  DateTime time;
  int likes;

  Color? mainColor;
  Color? altColor;
  Image? image;

  SocialPost(
      {required this.description,
      required this.postID,
     required this.firstName,
        required this.lastName,
        required this.clientId,
       this.pic,
      required this.time,
      required this.likes,
      this.mainColor,
      this.altColor,
      this.image});

  factory SocialPost.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return SocialPost(
        description: data?['description'],
        postID: data?['postID'],
        firstName: data?['firstName'],
        lastName: data?['lastName'],
        clientId: data?['clientId'],
        pic: data?['pic'],
        time: data?['time'],
        likes: data?['likes'],
        mainColor: data?['mainColor'],
        altColor: data?['altColor'],
        image: data?['image']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      'description': description,
      'postID': postID,
      "firstName":firstName,
      "lastName": lastName,
      'clientId': clientId,
      'pic': pic,
      'time': time,
      'likes': likes,
      'mainColor': mainColor,
      'altColor': altColor,
      'image': image,
    };
  }
}
