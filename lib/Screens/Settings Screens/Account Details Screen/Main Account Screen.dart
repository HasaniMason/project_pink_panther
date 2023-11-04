import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Widgets/BigUserCircle.dart';
import 'package:top_tier/Widgets/UserCircleWithInitials.dart';

class MainAccountScreen extends StatefulWidget {
  Client client;

  MainAccountScreen({super.key, required this.client});

  @override
  State<MainAccountScreen> createState() => _MainAccountScreenState();
}

class _MainAccountScreenState extends State<MainAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          //alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Stack(

                children: [
                  TopContainer(context),
                  InfoPanel(context),

                  Positioned(
                    top:520,
                      left: 100,
                      child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Row(
                            children: [
                              Text('Next Appointment: ',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),

                              ///insert appointment info here
                            ],
                          ),
                          ElevatedButton(onPressed: (){}, child: Text("Edit Phone Number",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),)),
                          ElevatedButton(onPressed: (){}, child: Text("Email Top Tier",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),)),

                          Text("Logo Here",style: Theme.of(context).textTheme.displayMedium,)
                        ],
                      )
                  )
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Positioned InfoPanel(BuildContext context) {
    return Positioned(
                  top: 250,
                  left: 10,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor,
                              blurRadius: 15
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('Email',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),),
                              Text(widget.client.email,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),)
                            ],
                          ),

                          Column(
                            children: [
                              Text('Phone Number',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),),
                              Text(widget.client.phoneNumber,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),)
                            ],
                          ),

                          Column(
                            children: [
                              Text('Account Status',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),),

                              widget.client.activeAccount ?
                              Text('Active',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),):
                              Text('Restricted',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),)
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                );
  }

  Container TopContainer(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24))),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Text('My Account',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Theme.of(context).primaryColor))
                ],
              ),
              BigUserCircle(
                client: widget.client,
              ),
              Text(
                '${widget.client.firstName} ${widget.client.lastName}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              )
            ],
          ),
        );
  }
}
