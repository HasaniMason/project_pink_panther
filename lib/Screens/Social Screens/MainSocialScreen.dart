import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Firebase/ClientFirebase/SocialFirebase.dart';
import '/Custom%20Data/Clients.dart';
import '/Custom%20Data/SocialPost.dart';
import '/Screens/Social%20Screens/AddSocialPost.dart';
import '/Widgets/SocialFeedWidget.dart';
import '/Widgets/UserCircleWithInitials.dart';

import '../../Custom Data/SocialPost.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Main screen for social screen
class MainSocialScreen extends StatefulWidget {
  Client client;

  MainSocialScreen({super.key, required this.client});

  @override
  State<MainSocialScreen> createState() => _MainSocialScreenState();
}

class _MainSocialScreenState extends State<MainSocialScreen> {

  SocialFirebase socialFirebase = SocialFirebase();
  List<DocumentSnapshot> postList = [];

   Stream<QuerySnapshot> socialPostStream =
      FirebaseFirestore.instance.collection('socialPost').snapshots();

   setUp()async{
     socialPostStream =
         FirebaseFirestore.instance.collection('socialPost').snapshots();
   }


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setUp(),
      //initialData: Text('Loading'),
      builder: (BuildContext context, AsyncSnapshot text){
      return Scaffold(
        appBar: AppBar(
          leading: UserCircleWithInitials(
            client: widget.client,
          ),
          actions: [
            IconButton(
                onPressed: () async {

                 await showModalBottomSheet(
                      context: context,
                      builder: (context) => AddSocialPost(client: widget.client)).then((value) => setState((){
                   socialPostStream =
                       FirebaseFirestore.instance.collection('socialPost').snapshots();
                 }));

                },
                icon: Icon(
                  Icons.add_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Social Feed',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).primaryColor)),
            ),


            Expanded(
              //build stream for social feed
              child: StreamBuilder(
                  stream: socialPostStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {

                    //if there is an error
                    if(snapshot.hasError){
                      return const Text('Error');
                    }
                    //while it connects
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    postList = snapshot.data!.docs;

                    //listview
                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          SocialPost thisPost = SocialPost(
                              description: postList[index]['description'],
                              postID: postList[index]['postID'],
                              firstName: postList[index]['firstName'],
                              lastName: postList[index]['lastName'],
                              clientId: postList[index]['clientId'],
                              time: (postList[index]['time']as Timestamp).toDate(),
                              likes: postList[index]['likes'],
                          pic: postList[index]['pic'] ?? 'null');

                          //return each post in custom widget
                          return SocialFeedWidget(
                            key:  ObjectKey(thisPost),
                            socialPost: thisPost,
                            firstName: thisPost.firstName,
                            lastName: thisPost.lastName,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox();
                        },
                        itemCount: postList.length);
                  }),
            )
          ],
        ),
      );
    }
    );
  }
}
