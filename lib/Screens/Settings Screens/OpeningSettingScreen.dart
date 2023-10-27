import 'package:flutter/material.dart';
import '/Custom%20Data/Clients.dart';

class OpeningSettingScreen extends StatefulWidget {
  Client client;

  OpeningSettingScreen({super.key, required this.client});

  @override
  State<OpeningSettingScreen> createState() => _OpeningSettingScreenState();
}

class _OpeningSettingScreenState extends State<OpeningSettingScreen> {
  bool notifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 16),
            child: Text('Settings',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Theme.of(context).primaryColor)),
          ),

          //list of settings item
          settingsItems(context),

          SizedBox(
            height: 150,
          ),

          CITexQoute(context)
        ],
      ),
    );
  }

  SafeArea CITexQoute(BuildContext context) {
    return SafeArea(child: Column(
          children: [
            Center(child: Text('Logo Here',style: Theme.of(context).textTheme.displayMedium,)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text('Powered by',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),),
                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('lib/Images/CITex_noBack copy.png')
                ),
              ],
            )
          ],
        ));
  }

  Padding settingsItems(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(left: 8, right: 42),
          child: Column(
            children: [

              //Notification toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  Switch(
                    activeColor: Theme.of(context).colorScheme.primary,
                      value: notifications,
                      onChanged: (value){
                      setState(() {
                        notifications = !notifications;
                      });
                      })
                ],
              ),

              //Account Details button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text('Account Details',style: TextStyle(color: Theme.of(context).colorScheme.primary),),

                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).colorScheme.primary,))
                ],
              ),

              //Payment info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text('Payment Method',style: TextStyle(color: Theme.of(context).colorScheme.primary),),

                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).colorScheme.primary,))
                ],
              ),


              //Private Policy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text('Privacy Policy',style: TextStyle(color: Theme.of(context).colorScheme.primary),),

                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).colorScheme.primary,))
                ],
              )
            ],
          ),
        );
  }
}
