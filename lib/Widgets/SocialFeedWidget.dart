import 'package:flutter/material.dart';

import '../Custom Data/Clients.dart';
import '../Custom Data/SocialPost.dart';
import 'UserCircleWithInitials.dart';

class SocialFeedWidget extends StatefulWidget {
  SocialPost socialPost;
  Client client;

  SocialFeedWidget({super.key, required this.socialPost, required this.client});

  @override
  State<SocialFeedWidget> createState() => _SocialFeedWidgetState();
}

class _SocialFeedWidgetState extends State<SocialFeedWidget> {
  TimeOfDay? formatTime;
  String amOrPm = 'AM';

  @override
  void initState() {
    super.initState();

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


              Body(context),

            ],
          ),
        ),
      ),
    );
  }

  Widget Body(BuildContext context) {
    return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${widget.socialPost.description}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ),

                //if there is a picture, show on post.
                widget.socialPost.pic != null ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        height: 200,
                          child: Image.asset(widget.socialPost.pic!)
                      ),
                    ):
                    const SizedBox()
              ],
            );
  }


  PopupMenuItem buildMenuItem(String title, IconData iconData){
    return PopupMenuItem(child:
    Row(
      children: [
        Icon(iconData),
        Text(title),
      ],
    )
    );
  }


  Widget TopRowButtons() {
    return Column(
      children: [
        //display user circle and 3 dot menu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserCircleWithInitials(client: widget.client),
            ),
            PopupMenuButton(itemBuilder: (context)=>
            [
              buildMenuItem('Delete', Icons.delete_outline)
            ],
            icon: const Icon(Icons.more_horiz_outlined),)

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
              Text(
                "${widget.client.firstName} ${widget.client.lastName}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
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
}
