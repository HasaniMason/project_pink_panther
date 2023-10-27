import 'package:flutter/material.dart';

import '../../../Custom Data/Clients.dart';
import '../../../Custom Data/Items.dart';



class SelectedItemScreen extends StatefulWidget {

  Client client;
  Item item;

  SelectedItemScreen({super.key, required this.client, required this.item});

  @override
  State<SelectedItemScreen> createState() => _SelectedItemScreenState();
}

class _SelectedItemScreenState extends State<SelectedItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(24)
        ),

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
                            .copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),

                      Text("Amount Avail.: ${widget.item.amountAvailable}",style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).colorScheme.primary),)
                    ],
                  ),
                ),
              ],
            ),


            //item image
            Image.asset(widget.item.picLocation ?? "lib/Images/Image_not_available.png"),


            //widget for item info
            itemInfo()
          ],
        ),
      ),
    );
  }



  Widget itemInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(widget.item.itemName,style: Theme.of(context).textTheme.bodyMedium!
          .copyWith(color: Theme.of(context).primaryColor)),

          Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    //if not on sale
                    if(widget.item.onSale == false )Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("\$${widget.item.retail}",style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                          color: Colors.black
                      ),),
                    ),

                    //if on sale, show crossed out original price
                    if ( widget.item.onSale == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "\$${widget.item.retail}",
                              style: const TextStyle( color: Colors.black,
                                  decoration: TextDecoration.lineThrough),
                            ),

                           const SizedBox(
                              width: 25,
                            ),

                            if (widget.item.salePrice != null) Text("\$${widget.item.salePrice ?? "TBD \$" }",style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              color: Colors.black
                            ))
                          ],
                        ),
                      )
                  ],
                ),
          
          Text('Description',style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.secondary),),
          
          Text(widget.item.itemDescription,style: const TextStyle(color: Colors.grey,fontSize: 18),)
        ],
      ),
    );
  }
}
