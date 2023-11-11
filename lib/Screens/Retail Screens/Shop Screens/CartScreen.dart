import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';


import '../../../Custom Data/Items.dart';
import 'package:http/http.dart' as http;

import '../../../Firebase/Firebase/ShopOrdersFirebase.dart';
import '../../../Firebase/Firebase/ShoppingCartFirebase.dart';

class CartScreen extends StatefulWidget {
  final Client client;

  CartScreen({required this.client});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Stream<QuerySnapshot> cartStream;
  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();
  ShopOrdersFirebase shopOrdersFirebase = ShopOrdersFirebase();

  Map<String, dynamic>? paymentIntent;

  num cartTotal = 0.00;

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('clients')
        .doc(widget.client.id)
        .collection('cart')
        .snapshots();

    // cartTotal = await shoppingCartFirebase.getTotalForCart(widget.client);
  }

  @override
  void initState() {
    super.initState();

    DocumentReference totalReference =
        FirebaseFirestore.instance.collection('clients').doc(widget.client.id);

    totalReference.snapshots().listen((event) {
      if(mounted)
      setState(() {
        cartTotal = event.get('cartTotal');
      });
    });
  }

  List<DocumentSnapshot> cartList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(
                                context); //to go page to previous page
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cart',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                  theCartList(),
                  paymentInfo(context)
                ],
              ),
            ),
          );
        });
  }

  Padding paymentInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Products will be shipped to your address on file. Please make sure address is current on profile. All sales are final.",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          SafeArea(
              child: ElevatedButton(
                  onPressed: () {
                    makePayment();
                  }, child: Text("Pay \$${cartTotal.toStringAsFixed(2)}")))
        ],
      ),
    );
  }

  Expanded theCartList() {
    return Expanded(
      child: StreamBuilder(
        stream: cartStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //if there is an error
          if (snapshot.hasError) {
            return const Text('Error');
          }
          //while it connects
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          cartList = snapshot.data!.docs;

          if (cartList.isEmpty) {
            return Center(
                child: Text(
              'Whoops... it looks empty in here. Add some items from the shop.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ));
          }

          return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Item thisItem = Item(
                    itemName: cartList[index]['itemName'],
                    retail: cartList[index]['retail'],
                    itemID: cartList[index]['itemID'],
                    itemDescription: cartList[index]['itemDescription'],
                    amountAvailable: cartList[index]['amountAvailable'],
                    onSale: cartList[index]['onSale'],
                    cost: cartList[index]['cost'],
                    picLocation: cartList[index]['picLocation'],
                    amountInCart: cartList[index]['amountInCart'],
                    salePrice: cartList[index]['salePrice']);

                return (CartTile(
                  item: thisItem,
                  client: widget.client,
                  cartTotal: cartTotal.toDouble(),
                ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox();
              },
              itemCount: cartList.length);
        },
      ),
    );
  }



  Future<void> makePayment() async {

    var newTotal = cartTotal.toString().replaceAll('.', '');
    try {
      //payment intent
       paymentIntent = await createPaymentIntent(newTotal, 'USD');

      //initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Top Tier'
        ),
      );

      //display payment sheet
       displayPaymentSheet();
    } catch (error) {
      throw Exception(error);
    }


  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      //make post request to stripe
      var response =
          await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
              headers: {
                'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body);
      return json.decode(response.body);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) => {

        setState(() {
      widget.client.cartTotal =cartTotal;
        }),

       shopOrdersFirebase.createOrderFromCart(widget.client),
        Navigator.pop(context)

      }).onError((error, stackTrace) => {throw Exception(error)});
    }catch (error){

    }  StripeException (error){
      print("error");
    }
  }
}

class CartTile extends StatefulWidget {
  final Item item;
  final Client client;
  double cartTotal;

  CartTile({required this.item, required this.client, required this.cartTotal});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();
  ShopOrdersFirebase shopOrdersFirebase = ShopOrdersFirebase();

  getCartTotal() async {
    widget.cartTotal =
        await shoppingCartFirebase.getTotalForCart(widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.itemName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18), softWrap: true,
                  ),

                  //if item is on sale
                  widget.item.onSale
                      ? Text(
                          '\$${widget.item.salePrice}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 15),
                        )
                      : Text('\$${widget.item.retail}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  widget.item.onSale
                      ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                            '\$${(widget.item.amountInCart! * widget.item.salePrice!).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                color:
                                Theme.of(context).colorScheme.secondary,
                                fontSize: 15)),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                            '\$${(widget.item.amountInCart! * widget.item.retail).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                color:
                                Theme.of(context).colorScheme.secondary,
                                fontSize: 15)),
                      ),

                  //container to modify amount
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //if amount in cart is 1, show trash icon

                        widget.item.amountInCart! == 1
                            ? IconButton(
                                onPressed: () async {
                                  //subtract item
                                  setState(() {
                                    widget.item.amountInCart = widget.item.amountInCart! -1;
                                  });

                                 await  shoppingCartFirebase.subtractionToItemInCart(
                                      widget.client, widget.item);

                                  setState(() {
                                    getCartTotal();
                                  });
                                },
                                icon: Icon(Icons.delete),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              )
                            : IconButton(
                                onPressed: () async {
                                  //subtract item


                                  setState(() {
                                    widget.item.amountInCart = widget.item.amountInCart! -1;
                                  });

                                  //update database
                                  await shoppingCartFirebase.subtractionToItemInCart(
                                      widget.client, widget.item);

                                  //update total for cart
                                  await shoppingCartFirebase
                                      .getTotalForCart(widget.client);


                                  setState(() {
                                    getCartTotal();
                                  });
                                },
                                icon: Icon(Icons.exposure_minus_1_outlined),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),

                        VerticalDivider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.item.amountInCart}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20)),
                        ),

                        VerticalDivider(
                          color: Colors.grey,
                        ),

                        IconButton(
                          onPressed: () async {
                            //add item

                            setState(() {
                              if(widget.item.amountInCart != null){
                                widget.item.amountInCart = widget.item.amountInCart! + 1;
                              }else{
                                widget.item.amountInCart = 1;
                              }
                            });

                            //update database
                           await  shoppingCartFirebase.additionToItemInCart(
                                widget.client, widget.item);

                           //update total for cart
                            await shoppingCartFirebase
                                .getTotalForCart(widget.client);

                            //set data for UI
                            setState(() {
                              print(shoppingCartFirebase.cartTotal);
                              widget.cartTotal = shoppingCartFirebase.cartTotal;
                            });

                          },
                          icon: Icon(Icons.plus_one_outlined),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
