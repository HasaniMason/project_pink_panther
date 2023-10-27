

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/SocialPost.dart';
import 'package:uuid/uuid.dart';

class SocialFirebase{

  addSocialPost(SocialPost socialPost,Client client){

    //get random number for id
    var uuid = const Uuid();

    var id = uuid.v4();

    socialPost.postID = id; //assign unique id to social post


    final docRef = FirebaseFirestore.instance
        .collection('socialPost')
        .withConverter(
        fromFirestore: SocialPost.fromFireStore,
        toFirestore: (SocialPost socialPost, options) => socialPost.toFireStore())
        .doc(id);

    docRef.set(socialPost);


  }

}