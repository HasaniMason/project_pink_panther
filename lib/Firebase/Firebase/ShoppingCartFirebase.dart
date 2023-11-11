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
  deleteItemFromCart(Client client, Item item) {
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .collection('cart')
        .doc(item.itemID);

    docRef.delete();
  }

  double cartTotal = 0.00;
  ///get total for cart
  Future<double> getTotalForCart(Client client) async {

    cartTotal = 0.00;     //reset total to zero

    //create reference to client' cart
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .collection('cart').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //get reference documents and get all totals
    await docRef.get().then((value) async => {

      for(var docSnap in value.docs){   //iterate through each document
        if(docSnap.data().onSale){    //if item is on sale, add sale price, else add regular retail price

          cartTotal += (docSnap.data().salePrice!.toDouble()) * docSnap.data().amountInCart!,
          print("${cartTotal}"),
        }else{
          cartTotal += (docSnap.data().retail)* docSnap.data().amountInCart!
        }
      }
    });
    final clientRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id).withConverter(
        fromFirestore: Client.fromFireStore,
        toFirestore: (Client client, options) => client.toFireStore());

    await clientRef.update({'cartTotal':cartTotal});



    print("In shopping cart total: $cartTotal");
    return cartTotal;

  }


  additionToItemInCart(Client client, Item item) async {
   // item.amountInCart = item.amountInCart?? 0 + 1;



      //create reference to client' cart
      final docRef = FirebaseFirestore.instance
          .collection('clients')
          .doc(client.id)
          .collection('cart').doc(item.itemID).withConverter(
          fromFirestore: Item.fromFireStore,
          toFirestore: (Item item, options) =>
              item.toFireStore());


      if (item.amountInCart != null){
        await docRef.update({"amountInCart": item.amountInCart});
      }else{
        item.amountInCart =1;
        docRef.set(item);
      }



    //docRef.update({'amountInCart':item.amountInCart});
  }

  subtractionToItemInCart(Client client, Item item){

    //create reference to client' cart
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(client.id)
        .collection('cart').doc(item.itemID).withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    if(item.amountInCart! <= 0){
      docRef.delete();
    }else{
      docRef.update({'amountInCart':item.amountInCart});
    }

    this.getTotalForCart(client);


  }


  ///empty shopping cart
clearShoppingCart(Client client){
  final docRef = FirebaseFirestore.instance
      .collection('clients')
      .doc(client.id)
      .collection('cart');

  var newRef;

  final docSnap = docRef.get();

  docSnap.then((value) => {
    for(var docSnapShot in value.docs){

       newRef = FirebaseFirestore.instance
          .collection('clients')
      .doc(client.id)
      .collection('cart')
      .doc(docSnapShot.id).delete(),

    }
  });
}
}
