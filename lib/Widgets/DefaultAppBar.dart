
import 'package:flutter/material.dart';

import 'UserCircleWithInitials.dart';
import '../../Custom Data/Clients.dart';



class DefaultAppBar extends StatefulWidget {
  Client client;

  DefaultAppBar({super.key, required this.client});

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Hero(
        tag: 'Hero',
        child: Text(
          "Logo Here",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      centerTitle: true,
      //to center title/logo
      backgroundColor: Colors.white,
      leading: UserCircleWithInitials(
        client: widget.client,
      ),
      //user circle avatar

      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.search_outlined))
      ],
    );
  }
}
