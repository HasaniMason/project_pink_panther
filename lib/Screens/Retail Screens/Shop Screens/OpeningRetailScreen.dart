import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/material.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:top_tier/AdminRoles/AdminShop/ShopAdminScreen.dart';
import 'package:top_tier/Screens/Retail%20Screens/Shop%20Screens/CartScreen.dart';

import '../../../Custom Data/Clients.dart';
import '../../../Custom Data/Items.dart';
import '../../../Firebase/Firebase/ItemCatalogFirebase.dart';
import '../../../Widgets/ItemTile.dart';
import '../../../Widgets/UserCircleWithInitials.dart';
import 'SelectedItemScreen.dart';
import 'package:animation_search_bar/animation_search_bar.dart';

class OpeningRetailScreen extends StatefulWidget {
  Client client;

  OpeningRetailScreen({super.key, required this.client});

  @override
  State<OpeningRetailScreen> createState() => _OpeningRetailScreenState();
}

class _OpeningRetailScreenState extends State<OpeningRetailScreen> {
  ItemCatalogFirebase itemCatalogFirebase = ItemCatalogFirebase();
  TextEditingController searchController = TextEditingController();

  List<Item> itemCatalog = [];

  List<Item> filterList = [];
  setUp() async {
    print("Here in Opening Retail Screen");
    itemCatalog = await itemCatalogFirebase.getItemCatalog();

    //filterList = itemCatalog;
  }

  @override
  void initState(){
    super.initState();
//setUp();
    //filterList = itemCatalog;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
              appBar: AppBar(
                title: Hero(
                  tag: 'Hero',
                  child: SizedBox(
                      height: 100,
                      child: Image.asset(
                          'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
                ),
                centerTitle: true,
                //to center title/logo
                backgroundColor: Colors.white,
                leading: UserCircleWithInitials(
                  client: widget.client,
                ),
                //user circle avatar

                actions: [
                  if (widget.client.admin)
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopAdminScreen()));
                        },
                        icon: Icon(Icons.admin_panel_settings_outlined)),
                  IconButton(
                      onPressed: () {
                        showCupertinoModalSheet(
                            context: context,
                            builder: (context) => CartScreen(
                                  client: widget.client,
                                ));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined)),
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
                            Navigator.pop(
                                context); //to go page to previous page
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
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                  // AnimationSearchBar(
                  //   centerTitle: 'search item...',
                  //     onChanged: (text) => {
                  //     setState((){
                  //       itemCatalog = itemCatalog.where((element) => element.itemName.toLowerCase().contains(text.toLowerCase())).toList();
                  //
                  //     })
                  //     },
                  //     searchTextEditingController: searchController,
                  // isBackButtonVisible: false,
                  // ),


                  Expanded(
                    child: ResponsiveGridList(
                      rowMainAxisAlignment: MainAxisAlignment.center,
                      horizontalGridSpacing: 16,
                      verticalGridSpacing: 16,
                      minItemsPerRow: 2,
                      maxItemsPerRow: 2,
                      listViewBuilderOptions: ListViewBuilderOptions(),
                      minItemWidth: 165,
                      children:
                      List.generate(
                          itemCatalog.length,
                          (index) => InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedItemScreen(client: widget.client, item: itemList[index])));

                                  showCupertinoModalSheet(
                                      context: context,
                                      builder: (context) => SelectedItemScreen(
                                            client: widget.client,
                                            item: itemCatalog[index],
                                          ));
                                },
                                child: ItemTile(
                                  item: itemCatalog[index],
                                ),
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
        });
  }
}
