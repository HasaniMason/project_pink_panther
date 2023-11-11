import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

import '../Custom Data/Items.dart';

//tile for items
class ItemTile extends StatefulWidget {
  Item item;

  ItemTile({super.key, required this.item});

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  String? url;

  setUp() async {
    if (widget.item.picLocation != null && widget.item.picLocation != 'null') {
      var ref = await FirebaseStorage.instance.ref().child(widget.item.picLocation?? "");

      print(widget.item.picLocation);
      try {
        await ref.getDownloadURL().then((value) => setState(() {
              url = value;

              //url = 'https://${url!}';
            }));
      } on FirebaseStorage catch (e) {
        print('Did not get URL: ${e}');
      }
    }
  }

  @override
  void initState(){
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (BuildContext context, AsyncSnapshot text) {
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
                            const BoxShadow(color: Colors.grey, blurRadius: 5)
                          ]),
                      child: widget.item.picLocation != null
                          ?
                      url != null ?
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(url.toString(),fit: BoxFit.fill,)):
                          CircularProgressIndicator()
                          : Image.asset('lib/Images/Image_not_available.png'))),
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
                              "\$${widget.item.retail.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.black, fontSize: 14),
                            ),
                          if (widget.item.onSale == true)
                            Text(
                              "\$${widget.item.retail.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough),
                            ),
                          if (widget.item.salePrice != null)
                          Text("\$${widget.item.salePrice!.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                  ))
                        ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
