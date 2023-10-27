import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Custom%20Data/Clients.dart';

class SocialPost {
  String description;
  String postID;

  Client client;
  String? pic;

  DateTime time;
  int likes;

  Color? mainColor;
  Color? altColor;
  Image? image;

  SocialPost(
      {required this.description,
      required this.postID,
      required this.client,
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
        client: data?['client'],
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
      'client': client,
      'pic': pic,
      'time': time,
      'likes': likes,
      'mainColor': mainColor ?? Colors.white,
      'altColor': altColor ?? Colors.white,
      'image': image,
    };
  }
}
