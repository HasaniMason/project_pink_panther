import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_tier/Screens/Social%20Screens/MainSocialScreen.dart';
import '../../Firebase/Firebase/SocialFirebase.dart';
import '/Custom%20Data/Clients.dart';
import 'package:images_picker/images_picker.dart';

import '../../Custom Data/SocialPost.dart';
import '../../Widgets/UserCircleWithInitials.dart';


class AddSocialPost extends StatefulWidget {
  Client client;



  AddSocialPost({super.key, required this.client});

  @override
  State<AddSocialPost> createState() => _AddSocialPostState();
}

class _AddSocialPostState extends State<AddSocialPost> {
  String? path;

  SocialPost socialPost = SocialPost(
      description: '',
      postID: 'agaghhh',
      firstName: '',
      lastName: '',
      clientId: '',
      time: DateTime.now(),
      likes: 0);

  TextEditingController editingController = TextEditingController();
  SocialFirebase socialFirebase = SocialFirebase();

  Future getImage() async {
    List<Media>? res =
        await ImagesPicker.pick(count: 1, pickType: PickType.image);

    setState(() {
      path = res?[0].thumbPath;
    });

    if(path != null){
      print(path);
    }

//bool status = await ImagesPicker.saveImageToAlbum(File(res![0]!.thumbPath!));
// print(status);
  }

  @override
  void initState() {
    super.initState();

    socialPost.clientId = widget.client.id; //assign client to social post
    socialPost.firstName = widget.client.firstName;
    socialPost.lastName = widget.client.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // UserCircleWithInitials(client: widget.client)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopRowButtons(context),

            //if pic is picked, show image of it. If not show nothing
            if (path != null)
              ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    path!,
                    height: 100,
                    width: 100,
                  ))
            else
              const SizedBox(),

            //if
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: editingController,
                decoration: InputDecoration.collapsed(
                  hintStyle: GoogleFonts.sriracha(
                      textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  hintText: 'Enter Description...',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding TopRowButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserCircleWithInitials(client: widget.client),
          Row(
            children: [
              //button to attach file
              IconButton(
                onPressed: () {
                  getImage();
                },
                icon: const Icon(Icons.attach_file_outlined),
              ),

              //Submit button to post
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {
                  setState(() {
                    socialPost.description = editingController.text;
                    socialPost.time = DateTime.now();
                    // socialPost?.pic = path;

                  });


                 await socialFirebase.addSocialPost(socialPost, widget.client, path);

                 Navigator.pop(context);
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
