import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';

import '../../Custom Data/Items.dart';

///class to handle shopping cart and making purchases
class ShoppingCartFirebase {
  ///add an item to cart
  addItemToCart(Client client, Item item) {
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .collection('cart')
        .doc(item.itemID).withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());


    if(item.amountInCart != null){
      item.amountInCart = item.amountInCart! + 1;
    }else{
      item.amountInCart = 1;
    }

    docRef.set(item);

  }

  ///remove item from cart
  deleteItemFromCart(Client client, Item item) {}

  ///get total for cart
  getTotalForCart(Client client) {}
}
