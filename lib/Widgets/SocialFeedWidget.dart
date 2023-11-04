import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Firebase/ClientFirebase/SocialFirebase.dart';

import '../Custom Data/Clients.dart';
import '../Custom Data/SocialPost.dart';
import 'UserCircleWithInitials.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';

class SocialFeedWidget extends StatefulWidget {
  SocialPost socialPost;
  Client? client;
  String? firstName;
  String? lastName;

  SocialFeedWidget(
      {super.key,
      required this.socialPost,
      this.client,
      this.firstName,
      this.lastName});

  @override
  State<SocialFeedWidget> createState() => _SocialFeedWidgetState();
}

class _SocialFeedWidgetState extends State<SocialFeedWidget> with AutomaticKeepAliveClientMixin {
  // final storage =
  //     FirebaseStorage.instance.refFromURL('gs://top-tier-9814f.appspot.com');

  TimeOfDay? formatTime;
  String amOrPm = 'AM';

  String? url;

  SocialFirebase socialFirebase = SocialFirebase();
   Uint8List? imageBytes;
  String? errorMsg;



  @override
  void initState() {
    super.initState();


    print("Debug: ${widget.socialPost.pic!}");

    if(widget.socialPost.pic != null || widget.socialPost.pic != 'null' ) {
      var ref = FirebaseStorage.instance.ref().child(widget.socialPost.pic!);

      ref.getDownloadURL().then((value) => setState((){
        url = value;

        //url = 'https://${url!}';
      }));

    }

    //create reference to document and check for updates
    // DocumentReference reference = FirebaseFirestore.instance
    //     .collection('socialPost')
    //     .doc(widget.socialPost.clientId);
    //
    // reference.snapshots().listen((querySnapshot){
    //   setState(() {
    //     widget.socialPost.pic = querySnapshot.get('pic');
    //   });
    // });

    //place time of post in new variable
    formatTime = TimeOfDay(
        hour: widget.socialPost.time.hour,
        minute: widget.socialPost.time.minute);

    //if time is PM, change variable to PM.... there may be a better way to do this
    if (widget.socialPost.time.hour >= 12) {
      amOrPm = "PM";
    }

    //convert hour to 12 hour format
    formatTime = formatTime?.replacing(hour: formatTime?.hourOfPeriod);


  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        shadowColor: Theme.of(context).colorScheme.primary,
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          //height: 300,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              TopRowButtons(),
              Body(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget Body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.socialPost.description,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),
        ),

        //if there is a picture, show on post.
        widget.socialPost.pic == null || widget.socialPost.pic == 'null' ||url.toString() == "null"
            ?
        const SizedBox():
        Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20)),
         // height: 200,
          child:

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(url.toString(),fit: BoxFit.fitWidth,
                  ),
                )

        )

      ],
    );
  }

  // PopupMenuItem buildMenuItem(
  //     String title, IconData iconData, Function function) {
  //   return PopupMenuItem(
  //       child: Row(
  //     children: [
  //       IconButton(
  //           onPressed: ()=> function,
  //           icon: Icon(iconData)),
  //       Text(title),
  //     ],
  //   ));
  // }

  Widget TopRowButtons() {
    return Column(
      children: [
        //display user circle and 3 dot menu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: UserCircleWithInitials(
                firstName: widget.firstName,
                lastName: widget.lastName,
              ),
            ),
            // PopupMenuButton(
            //   itemBuilder: (context) => [
            //     buildMenuItem('Delete', Icons.delete_outline, () {
            //       socialFirebase.deletePost(widget.socialPost);
            //     })
            //   ],
            //   icon: const Icon(Icons.more_horiz_outlined),
            // )

            Row(
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    if(widget.socialPost.pic != null && widget.socialPost.pic != 'null' ) {
                      var ref = FirebaseStorage.instance.ref().child(widget.socialPost.pic!);
                      ref.getDownloadURL().then((value) => setState((){
                        url = value;

                        //url = 'https://${url!}';
                      }));
                    }
                  });
                }, icon: Icon(Icons.refresh_outlined)),
                IconButton(
                    onPressed: () {
                      socialFirebase.deletePhoto(widget.socialPost);
                      socialFirebase.deletePost(widget.socialPost);
                    },
                    icon: Icon(Icons.delete_outline))
              ],
            )

            // IconButton(
            //     onPressed: () {
            //       popupButton();
            //     },
            //     icon: const Icon(
            //       Icons.more_horiz_outlined,
            //       color: Colors.black,
            //     ))
          ],
        ),

        //Display name and time of post
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //display first and last name
              widget.client != null
                  ? Text(
                      "${widget.client?.firstName} ${widget.client?.lastName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black),
                    )
                  : Text(
                      "${widget.firstName} ${widget.lastName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black),
                    ),

              //display time and date
              Column(
                children: [
                  Text(
                    "${formatTime?.hour ?? ''}:${formatTime?.minute ?? ''} $amOrPm",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black, fontSize: 14),
                  ),
                  Text(
                    "${widget.socialPost.time.month}-${widget.socialPost.time.day}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black, fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
