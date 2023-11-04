

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/SocialPost.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SocialFirebase{

  addSocialPost(SocialPost socialPost,Client client, String? path){

    //get random number for id
    var uuid = const Uuid();

    var id = uuid.v4();

    socialPost.postID = id; //assign unique id to social post

    //if path is not null and a picture has been picked
    if(path != null){
      uploadPic(path, socialPost);  //created function to upload pic to database
      socialPost.pic = 'TopTier/images/socialPosts/socialPosts${socialPost.postID}.jpg';  //store path to database in variable to reference later
    }




    final docRef = FirebaseFirestore.instance
        .collection('socialPost')
        .withConverter(
        fromFirestore: SocialPost.fromFireStore,
        toFirestore: (SocialPost socialPost, options) => socialPost.toFireStore())
        .doc(id);

    docRef.set(socialPost);

  }

  deletePost(SocialPost socialPost){
    print("In delete: ${socialPost.postID}");
    final docRef = FirebaseFirestore.instance
        .collection('socialPost')
        .doc(socialPost.postID);


    docRef.delete();
  }

  uploadPic(String path, SocialPost socialPost) async {
    final storageRef = FirebaseStorage.instance.ref();

    final refString = 'TopTier/images/socialPosts/socialPosts${socialPost.postID}.jpg';

    final socialRef = storageRef.child(refString);
    //final socialImagesRef = storageRef.child('images/$refString.jpg');

    // assert(socialRef.name == socialImagesRef.name);
    // assert(socialRef.fullPath != socialImagesRef.fullPath);

    File file = File(path);

    try{
      await socialRef.putFile(file);
    }on FirebaseException catch (e){
      print("Picture Error: $e");
    }
  }



  Future<String> downloadPic(SocialPost socialPost) async {



    final storageRef = FirebaseStorage.instance.ref();

    if(socialPost.pic !=  null) {
      final pathReference = storageRef.child(socialPost.pic!);
      final imageUrl = await pathReference.getDownloadURL();
      return imageUrl;
    }

    return '';


  }


  deletePhoto(SocialPost socialPost) async {
    final storageRef = FirebaseStorage.instance.ref();

    final refString = 'TopTier/images/socialPosts/socialPosts${socialPost.postID}.jpg';

    final socialRef = storageRef.child(refString);

    await socialRef.delete();
  }
}