import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/AdminRoles/AdminShop/AddItemAdminScreen.dart';
import 'package:top_tier/AdminRoles/AdminShop/EditShopItem.dart';

import '../../Custom Data/Items.dart';

class ShopAdminScreen extends StatefulWidget {
  const ShopAdminScreen({Key? key}) : super(key: key);

  @override
  State<ShopAdminScreen> createState() => _ShopAdminScreenState();
}

class _ShopAdminScreenState extends State<ShopAdminScreen> {
  Stream<QuerySnapshot> itemCatalogStream =
      FirebaseFirestore.instance.collection('itemCatalog').snapshots();

  List<DocumentSnapshot> itemList = [];

  setUp() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                  height: 100,
                  child: Image.asset(
                      'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
              actions: [
                IconButton(
                    onPressed: () {
                      showCupertinoModalSheet(
                              context: context,
                              builder: (context) => AddItemAdminScreen())
                          .then((value) => {setState(() {})});
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context); //to go page to previous page
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Admin - Shop',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: itemCatalogStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      //if there is an error
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      //while it connects
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      itemList = snapshot.data!.docs;

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            Item thisItem = Item(
                                itemName: itemList[index]['itemName'],
                                retail: itemList[index]['retail'],
                                itemID: itemList[index]['itemID'],
                                itemDescription: itemList[index]
                                    ['itemDescription'],
                                amountAvailable: itemList[index]
                                    ['amountAvailable'],
                                onSale: itemList[index]['onSale'],
                                cost: itemList[index]['cost'],
                                picLocation: itemList[index]['picLocation'],
                                amountInCart: itemList[index]['amountInCart'],
                                salePrice: itemList[index]['salePrice']);

                            return GestureDetector(
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditShopItem(item: thisItem)))
                                    },
                                child: ItemWidget(item: thisItem));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                          itemCount: itemList.length);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ItemWidget extends StatefulWidget {
  final Item item;

  ItemWidget({required this.item});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  String? url;

  setUp() async {
    if (widget.item.picLocation != null || widget.item.picLocation != 'null') {
      var ref = FirebaseStorage.instance.ref().child(widget.item.picLocation!);

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
        builder: (BuildContext context, AsyncSnapshot text) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Item Name: ${widget.item.itemName}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),

                      ],
                    ),
                    Text('Cost: \$${widget.item.cost?.toStringAsFixed(2) ?? 0.00}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Retail: \$${widget.item.retail.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                        Text('Sale Status: ${widget.item.onSale}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Sale Price: \$${widget.item.salePrice?.toStringAsFixed(2) ?? 0.00}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary)),
                        Text(
                          'Amount Avail: ${widget.item.amountAvailable}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),

                      ],
                    ),
                    widget.item.picLocation == null ||
                            widget.item.picLocation == 'null' ||
                            url.toString() == "null"
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'lib/Images/Image_not_available.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            // height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                url.toString(),
                                fit: BoxFit.fitWidth,
                              ),
                            ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
