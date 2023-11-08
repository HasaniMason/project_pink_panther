import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Firebase/ClientFirebase/ShoppingCartFirebase.dart';

import '../../../Custom Data/Clients.dart';
import '../../../Custom Data/Items.dart';

class SelectedItemScreen extends StatefulWidget {
  Client client;
  Item item;
  String? url;

  SelectedItemScreen({super.key, required this.client, required this.item, this.url});

  @override
  State<SelectedItemScreen> createState() => _SelectedItemScreenState();
}

class _SelectedItemScreenState extends State<SelectedItemScreen> {

  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

  String? url;

  setUp() async {
    if (widget.item.picLocation != null || widget.item.picLocation != 'null') {
      var ref = FirebaseStorage.instance.ref().child(widget.item.picLocation!);

      //print(widget.item.picLocation);
      try {
        await ref.getDownloadURL().then((value) => setState(() {
          url = value;

          //url = 'https://${url!}';
        }));
      } on FirebaseStorage catch (e) {
        print('Did not get URL');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setUp(),
      builder: (BuildContext context, AsyncSnapshot text){
      return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        body: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Amount Avail: ${widget.item.amountAvailable}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              //item image
              url == null ?
              Image.asset("lib/Images/Image_not_available.png"):
                  Image.network(url.toString(),fit: BoxFit.fitWidth),

              //widget for item info
              itemInfo()
            ],
          ),
        ),
      );
  }
    );
  }

  Widget itemInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.item.itemName,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //if not on sale
              if (widget.item.onSale == false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "\$${widget.item.retail.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black),
                  ),
                ),

              //if on sale, show crossed out original price
              if (widget.item.onSale == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "\$${widget.item.retail.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      if (widget.item.salePrice != null)
                        Text("\$${widget.item.salePrice?.toStringAsFixed(2) ?? "TBD \$"}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black))
                    ],
                  ),
                )
            ],
          ),
          Text(
            'Description',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          Text(
            widget.item.itemDescription,
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
          ElevatedButton(
              onPressed: () async {
                await shoppingCartFirebase.addItemToCart(widget.client, widget.item);

                Navigator.pop(context);
              },
              child: Text(
                "Add to Cart",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ))
        ],
      ),
    );
  }
}
