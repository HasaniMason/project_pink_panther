import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:uuid/uuid.dart';

import '../../Custom Data/Items.dart';
import '../../Custom Data/ShopOrders.dart';
import 'ShoppingCartFirebase.dart';

class ShopOrdersFirebase {


  createOrderFromCart(Client client) async {
    var v4 = Uuid();
    var id = v4.v4();
    ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

    ShopOrders shopOrders = await ShopOrders(total: client.cartTotal!,
        streetAddress: client.addressLine1 ?? "",
        streetAddressContinued: client.addressLine2 ?? "",
        zipCode: client.zipCode ?? "",
        city: client.city ?? "",
        state: client.state ?? "",
        id: id,
        firstName: client.firstName,
        lastName: client.lastName,
        phoneNumber: client.phoneNumber,
        clientId: client.id,
        email: client.email,
    date: DateTime.now());

    //get shopping cart ref
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .collection('cart').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //set initial shop order info
    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).withConverter(
        fromFirestore: ShopOrders.fromFireStore,
        toFirestore: (ShopOrders shopOrders, options) =>
            shopOrders.toFireStore());

    startRef.set(shopOrders);

    //ref for order
    var orderRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).collection('items').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //add each item to order ref
    final docSnap = docRef.get().then((value) =>
    {
      for(var snap in value.docs){

        orderRef.add(snap.data())
      }
    });



    //clear cart
    shoppingCartFirebase.clearShoppingCart(client);

    final resetRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id);

    resetRef.update({'cartTotal': 0});
  }


}