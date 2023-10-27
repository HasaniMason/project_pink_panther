import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Custom Data/Clients.dart';

//Create circle avatar using user initails. Main use for app bar
class UserCircleWithInitials extends StatefulWidget {
  Client client;

  UserCircleWithInitials({super.key, required this.client});

  @override
  State<UserCircleWithInitials> createState() => _UserCircleWithInitialsState();
}

class _UserCircleWithInitialsState extends State<UserCircleWithInitials> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.client.firstName[0] ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
            ),
            Text(widget.client.lastName[0] ?? '',
                style:
                Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black))
          ],
        ),
      ),
    );
  }
}
