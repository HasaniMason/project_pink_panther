import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../Custom Data/Clients.dart';
import '../../../Custom Data/Items.dart';
import '../../../Widgets/ItemTile.dart';
import '../../../Widgets/UserCircleWithInitials.dart';
import 'SelectedItemScreen.dart';

class OpeningRetailScreen extends StatefulWidget {
  Client client;

  OpeningRetailScreen({super.key, required this.client});

  @override
  State<OpeningRetailScreen> createState() => _OpeningRetailScreenState();
}

class _OpeningRetailScreenState extends State<OpeningRetailScreen> {

  List itemList = [

    Item(
        itemName: "Standard Lashes",
        retail: 3.24,
        itemID: 'arahafha',
        itemDescription: 'lla. Praesent at ultricies nibh, quis placerat risus. Donec egestas maximus tristique. Pellentesque tellus lacus, varius in risus nec, feugiat consequat ligula. Aenean lobortis risus vitae porta dapibus. Quisque a viverra sem.',
        amountAvailable: 4,
        onSale: false,
        picLocation: 'lib/Images/TestImages/lashes1.jpeg'),


    Item(
        itemName: "Long Lashes",
        retail: 3.94,
        itemID: 'ahfhaf',
        itemDescription: 'Long Lashes for everyday use.',
        amountAvailable: 7,
        onSale: true,
        salePrice: 3.50,
        picLocation: 'lib/Images/TestImages/lashes2.jpeg'),

    Item(
        itemName: "Small Lashes",
        retail: 2.24,
        itemID: 'arahahahahafha',
        itemDescription: 'Small Lashes for everyday use.',
        amountAvailable: 13,
        onSale: false),

    Item(
        itemName: "Glue for Lashes",
        retail: 1.24,
        itemID: 'dahjtjatj',
        itemDescription: 'Glue for Lashes.',
        amountAvailable: 7,
        onSale: false),

    Item(
        itemName: "Lashes Set",
        retail: 10.24,
        itemID: 'aahahfartat',
        itemDescription: 'Lash set for everyday use.',
        amountAvailable: 2,
        onSale: true,
        salePrice: 9.99)
  ];
  List items = [
    ItemTile(
        item: Item(
            itemName: "Standard Lashes",
            retail: 3.24,
            itemID: 'arahafha',
            itemDescription: 'Standard Lashes for everyday use.',
            amountAvailable: 4,
            onSale: false,
            picLocation: 'lib/Images/TestImages/lashes1.jpeg'),
    ),
    ItemTile(
        item: Item(
            itemName: "Long Lashes",
            retail: 3.94,
            itemID: 'ahfhaf',
            itemDescription: 'Long Lashes for everyday use.',
            amountAvailable: 7,
            onSale: true,
            salePrice: 3.50,
            picLocation: 'lib/Images/TestImages/lashes2.jpeg')),
    ItemTile(
        item: Item(
            itemName: "Small Lashes",
            retail: 2.24,
            itemID: 'arahahahahafha',
            itemDescription: 'Small Lashes for everyday use.',
            amountAvailable: 13,
            onSale: false)),
    ItemTile(
        item: Item(
            itemName: "Glue for Lashes",
            retail: 1.24,
            itemID: 'dahjtjatj',
            itemDescription: 'Glue for Lashes.',
            amountAvailable: 7,
            onSale: false)),
    ItemTile(
        item: Item(
            itemName: "Lashes Set",
            retail: 10.24,
            itemID: 'aahahfartat',
            itemDescription: 'Lash set for everyday use.',
            amountAvailable: 2,
            onSale: true,
            salePrice: 9.99)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Hero(
            tag: 'Hero',
            child: SizedBox(height:100,child: Image.asset('lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
          ),
          centerTitle: true,
          //to center title/logo
          backgroundColor: Colors.white,
          leading: UserCircleWithInitials(
            client: widget.client,
          ),
          //user circle avatar

          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_outlined))
          ],
        ),
        body:
            //build a flexible grid of items
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Shop',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Theme.of(context).primaryColor)),
                ),
              ],
            ),
            Expanded(
              child: ResponsiveGridList(
                rowMainAxisAlignment: MainAxisAlignment.center,
                horizontalGridSpacing: 16,
                verticalGridSpacing: 16,
                minItemsPerRow: 2,
                maxItemsPerRow: 2,
                listViewBuilderOptions: ListViewBuilderOptions(),
                minItemWidth: 165,
                children: List.generate(items.length, (index) => InkWell(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedItemScreen(client: widget.client, item: itemList[index])));

                    showCupertinoModalSheet(context: context, builder: (context)=> SelectedItemScreen(client: widget.client, item: itemList[index]));
                  },
                  child: items[index],
                )),
              ),
            ),
          ],
        )

        // Row(
        //   children: [
        //     ItemTile(itemName: 'Lashes Large', pictureLocation: 'lib/Images/TestImages/lashes1.jpeg', price: 2.34, available: true),
        //     ItemTile(itemName: 'Lashes', pictureLocation: 'lib/Images/TestImages/lashes1.jpeg', price: 2.34,salePrice: 2.00, available: true),
        //
        //   ],
        // ),
        );
  }
}
