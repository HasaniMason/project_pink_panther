import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';


class BigUserCircle extends StatefulWidget {
  Client client;

  BigUserCircle({super.key, required this.client});

  @override
  State<BigUserCircle> createState() => _BigUserCircleState();
}

class _BigUserCircleState extends State<BigUserCircle> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        maxRadius: 60,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.client?.firstName[0] ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.black),
              ),

              widget.client.lastName.isNotEmpty ?
              Text(widget.client?.lastName[0] ?? '',
                  style:
                  Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.black)):const SizedBox()
            ],
          )
      ),
    );
  }
}
