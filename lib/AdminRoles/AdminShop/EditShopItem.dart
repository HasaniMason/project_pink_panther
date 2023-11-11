import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

import '../../Custom Data/Items.dart';
import '../../Firebase/Firebase/ItemCatalogFirebase.dart';
import '../../Widgets/InputTextFieldWidgets.dart';



class EditShopItem extends StatefulWidget {
  Item item;

  EditShopItem({required this.item});

  @override
  State<EditShopItem> createState() => _EditShopItemState();
}

class _EditShopItemState extends State<EditShopItem> {

  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  TextEditingController amountAvailable = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  String? picLocation;

  //Item item = Item(itemName: '', retail: 1.00, itemID: '', itemDescription: '', amountAvailable: 5, onSale: false);

  ItemCatalogFirebase itemCatalogFirebase = ItemCatalogFirebase();
  bool onSale = false;
  String? path;

  Future getImage() async {
    List<Media>? res =
    await ImagesPicker.pick(count: 1, pickType: PickType.image);

    setState(() {
      path = res?[0].thumbPath;
    });

    if (path != null) {
      print(path);
    }
  }

  @override
  void initState(){
    super.initState();

    itemNameController.text = widget.item.itemName;
    retailController.text = widget.item.retail.toString();
    itemDescription.text = widget.item.itemDescription;
    amountAvailable.text = widget.item.amountAvailable.toString();

    if(widget.item.salePrice != null)
    salePriceController.text = widget.item.salePrice.toString();

    if(widget.item.cost != null)
    costController.text = widget.item.cost.toString();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            itemCatalogFirebase.deleteItem(widget.item);

            Navigator.pop(context);
            Navigator.pop(context);
          }, icon: Icon(Icons.delete_outline))
        ],
        title: Container(
            height: 100,
            child: Image.asset(
                'lib/Images/Top Tier Logos/TopTierLogo_TRNS.png')),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Edit Item - ${widget.item.itemName}',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme.of(context).primaryColor)),
                  ),
                ),
              ],
            ),
            textFields(),
            buttons(context)
          ],
        ),
      ),
    );
  }
  Column buttons(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){
            getImage();
          }, child: Text("Upload a Picture")),
        ),
        ElevatedButton(onPressed: () async {

          setState(() {

            widget.item.itemName = itemNameController.text;
            widget.item.retail = double.parse(retailController.text);
            widget.item.itemDescription = itemDescription.text;
            widget.item.amountAvailable = int.parse(amountAvailable.text);

            if( widget.item.onSale){
              widget.item.salePrice = double.parse(salePriceController.text);
            }

            if(costController.text.isNotEmpty){
              widget.item.cost = double.parse(costController.text);
            }

          });

          ///method for update
          await itemCatalogFirebase.updateItem( widget.item, path);

          Navigator.pop(context);
        }, child: Text("Update Item")),


        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel"))
      ],
    );
  }
  
  Column textFields() {
    return Column(
      children: [
        InputTextFieldWidget(controller: itemNameController, hintText: 'Enter Item Name - required',textInputType: TextInputType.text,),

        InputTextFieldWidget(controller: retailController, hintText: 'Enter Retail - required',textInputType: TextInputType.numberWithOptions(decimal: true),),

        InputTextFieldWidget(controller: itemDescription, hintText: 'Enter Item Description - required',textInputType: TextInputType.text,),

        InputTextFieldWidget(controller: amountAvailable, hintText: 'Enter Amount Available - required',textInputType: TextInputType.numberWithOptions(decimal: true),),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(child: Text('Start Item on a sale? Can be changed later.',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),textAlign: TextAlign.center,)),
              Switch(value:  widget.item.onSale, onChanged: (value)=>{
                setState((){
                  widget.item.onSale = value;
                })
              }),
            ],
          ),
        ),

        widget.item.onSale ?
        InputTextFieldWidget(controller: salePriceController, hintText: 'Enter Sale Price',textInputType:TextInputType.numberWithOptions(decimal: true)):
        const SizedBox(),

        InputTextFieldWidget(controller: costController, hintText: 'Enter Cost for Item',textInputType:TextInputType.numberWithOptions(decimal: true)),

      ],
    );
  }
}
