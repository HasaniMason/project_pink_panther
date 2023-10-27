import 'package:flutter/material.dart';

import '../Custom Data/Items.dart';

//tile for items
class ItemTile extends StatefulWidget {
  Item item;

  ItemTile({super.key, required this.item});

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flexible(
            child: Container(
              width: 150,
                height: 100,
                decoration: BoxDecoration(
                   // color: Theme.of(context).primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      if(widget.item.picLocation != null)
                     const BoxShadow(
                          color: Colors.grey, blurRadius: 5
                      )
                    ]),
                child: Image.asset(
              widget.item.picLocation ??
                  "lib/Images/Image_not_available.png",
              fit: BoxFit.fitHeight,
            )),
          ),
          //shrink photo
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(24),
                ),
            width: 175,
            child: Column(
              children: [
                Text(widget.item.itemName,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 14)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.item.onSale == false)
                      Text(
                        "\$${widget.item.retail}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black, fontSize: 14),
                      ),
                    if (widget.item.onSale == true)
                      Text(
                        "\$${widget.item.retail}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough),
                      ),
                    if (widget.item.salePrice != null)
                      Text(
                        "\$${widget.item.salePrice ?? "TBD \$"}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black, fontSize: 14),
                      )
                  ],
                ),
                Text(
                  'Available: ${widget.item.amountAvailable}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
