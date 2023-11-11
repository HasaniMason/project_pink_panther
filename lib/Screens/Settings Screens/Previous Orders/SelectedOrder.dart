import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/ShopOrders.dart';

import '../../../Custom Data/Items.dart';

class SelectedOrder extends StatefulWidget {
  ShopOrders shopOrders;

  SelectedOrder({required this.shopOrders});

  @override
  State<SelectedOrder> createState() => _SelectedOrderState();
}

class _SelectedOrderState extends State<SelectedOrder> {
 late Stream<QuerySnapshot> itemCatalogStream;

  List<DocumentSnapshot> itemList = [];

  @override
  void initState() {
    super.initState();

    itemCatalogStream = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(widget.shopOrders.id)
        .collection('items')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Text('Past Orders',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ],
            ),
            Container(height: MediaQuery.of(context).size.height/2,
                child: orderList()),

            orderInfo(context),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,color: Theme.of(context).primaryColor,),

                Flexible(child: Text('${widget.shopOrders.id}',style: Theme.of(context).textTheme.bodySmall,))
              ],
            )
          ],
        ),
      ),
    );
  }

  Container orderInfo(BuildContext context) {
    return Container(
            child: Column(
              children: [
                Text("Order Total: \$${widget.shopOrders.total}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("Address: ${widget.shopOrders.streetAddress}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("${widget.shopOrders.streetAddressContinued}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("${widget.shopOrders.zipCode}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("${widget.shopOrders.city}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("${widget.shopOrders.state}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor))
              ],
            ),
          );
  }

  Widget orderList() {
    return StreamBuilder(
      stream: itemCatalogStream,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  itemDescription: itemList[index]['itemDescription'],
                  amountAvailable: itemList[index]['amountAvailable'],
                  onSale: itemList[index]['onSale'],
                  cost: itemList[index]['cost'],
                  picLocation: itemList[index]['picLocation'],
                  amountInCart: itemList[index]['amountInCart'],
                  salePrice: itemList[index]['salePrice']);

              return itemContainer(item: thisItem);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox();
            },
            itemCount: itemList.length);
      },
    );
  }
}


class itemContainer extends StatefulWidget {
  Item item;
  
  itemContainer({required this.item});

  @override
  State<itemContainer> createState() => _itemContainerState();
}

class _itemContainerState extends State<itemContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8, right: 24, left: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.item.itemName, style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).primaryColor)),

                Text('Amount: ${widget.item.amountInCart}', style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black))
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                widget.item.onSale?
                Text("\$${widget.item.salePrice}", style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).primaryColor)):
                Text("\$${widget.item.retail}", style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).primaryColor)),


                widget.item.onSale?
                Text("\$${(widget.item.salePrice ?? widget.item.retail) * widget.item.amountInCart!}", style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black)):
                Text("\$${widget.item.retail * widget.item.amountInCart!}", style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black)),
              ],
            ),


          ],
        ),
      ),
    );
  }
}



