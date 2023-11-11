import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Custom Data/ShopOrders.dart';
import '../../Screens/Settings Screens/Previous Orders/SelectedOrder.dart';




class SeeAllOrdersScreen extends StatefulWidget {
  const SeeAllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<SeeAllOrdersScreen> createState() => _SeeAllOrdersScreenState();
}

class _SeeAllOrdersScreenState extends State<SeeAllOrdersScreen> {

  List<DocumentSnapshot> orderList = [];
  Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance
      .collection('shopOrders')
      .orderBy('date',descending: false)
      .snapshots();

  TextEditingController searchController = TextEditingController();


  setUp() async {

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
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
                          color: Theme
                              .of(context)
                              .primaryColor,
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('All Orders',
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                color: Theme
                                    .of(context)
                                    .primaryColor)),
                      ),
                    ),
                  ],
                ),
                AnimationSearchBar(
                  centerTitle: 'search item...',
                  onChanged: (text) =>
                  {
                    setState(() {

                    })
                  },
                  searchTextEditingController: searchController,
                  isBackButtonVisible: false,
                ),
                list()
              ],
            ),
          );
        });
  }

  Expanded list() {
    return Expanded(
      child: StreamBuilder(
          stream: ordersStream,
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
            orderList = snapshot.data!.docs;

            if (searchController.text.length > 0) {
              orderList = orderList.where((element) {
                return element
                    .get('firstName')
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();
            }

            //listview
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  ShopOrders thisShopOrder = ShopOrders(
                      total: orderList[index]['total'],
                      streetAddress: orderList[index]['streetAddress'],
                      streetAddressContinued: orderList[index]
                      ['streetAddressContinued'],
                      zipCode: orderList[index]['zipCode'],
                      city: orderList[index]['city'],
                      state: orderList[index]['state'],
                      id: orderList[index]['id'],
                      firstName: orderList[index]['firstName'],
                      lastName: orderList[index]['lastName'],
                      phoneNumber: orderList[index]['phoneNumber'],
                      clientId: orderList[index]['clientId'],
                      email: orderList[index]['email'],
                      date: (orderList[index]['date'] as Timestamp).toDate());

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SelectedOrder(
                                      shopOrders: thisShopOrder,
                                    )));
                      },
                      child: orderContainer(shopOrders: thisShopOrder));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox();
                },
                itemCount: orderList.length);
          }),
    );
  }
}



class orderContainer extends StatefulWidget {
  final ShopOrders shopOrders;

  orderContainer({required this.shopOrders});

  @override
  State<orderContainer> createState() => _orderContainerState();
}

class _orderContainerState extends State<orderContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary, blurRadius: 2)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.shopOrders.firstName} ${widget.shopOrders
                        .lastName}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                  Text("${widget.shopOrders.phoneNumber}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${widget.shopOrders.total.toStringAsFixed(2)}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme
                          .of(context)
                          .primaryColor)),
                  Text("${widget.shopOrders.email}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
