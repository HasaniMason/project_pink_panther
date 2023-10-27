import 'package:flutter/material.dart';
import '/Custom%20Data/Clients.dart';
import '/Custom%20Data/SocialPost.dart';
import '/Screens/Social%20Screens/AddSocialPost.dart';
import '/Widgets/SocialFeedWidget.dart';
import '/Widgets/UserCircleWithInitials.dart';

import '../../Custom Data/SocialPost.dart';


//Main screen for social screen
class MainSocialScreen extends StatefulWidget {
  Client client;

  MainSocialScreen({super.key, required this.client});

  @override
  State<MainSocialScreen> createState() => _MainSocialScreenState();
}

class _MainSocialScreenState extends State<MainSocialScreen> {

  SocialPost? socialPost;
  SocialPost? secondPost;
  SocialPost? thirdPost;


  List<SocialPost> postList = [];


  @override
  void initState(){
    super.initState();



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: UserCircleWithInitials(client: widget.client,),
        actions: [
          IconButton(onPressed: (){
           showModalBottomSheet(context: context, builder: (context)=>AddSocialPost(client: widget.client,postList: postList,));
          }, icon: Icon(Icons.add_outlined,color: Theme.of(context).colorScheme.primary,))
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
              child: ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    return SocialFeedWidget(
                        socialPost: postList[index], client: widget.client);
                  }))
        ],
      ),
    );
  }
}
