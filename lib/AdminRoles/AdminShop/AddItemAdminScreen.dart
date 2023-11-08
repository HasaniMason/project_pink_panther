import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:top_tier/Custom%20Data/Items.dart';
import 'package:top_tier/Firebase/ClientFirebase/ItemCatalogFirebase.dart';
import 'package:top_tier/Widgets/InputTextFieldWidgets.dart';



class AddItemAdminScreen extends StatefulWidget {
  const AddItemAdminScreen({Key? key}) : super(key: key);

  @override
  State<AddItemAdminScreen> createState() => _AddItemAdminScreenState();
}

class _AddItemAdminScreenState extends State<AddItemAdminScreen> {

  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  TextEditingController amountAvailable = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  String? picLocation;

  Item item = Item(itemName: '', retail: 1.00, itemID: '', itemDescription: '', amountAvailable: 5, onSale: false);

  ItemCatalogFirebase itemCatalogFirebase = ItemCatalogFirebase();

  bool onSale = false;
  String? path;


  Future getImage() async {
    List<Media>? res =
    await ImagesPicker.pick(count: 1, pickType: PickType.image);

    setState(() {
      path = res?[0].thumbPath;
    });

    if(path != null){
      print(path);
    }

//bool status = await ImagesPicker.saveImageToAlbum(File(res![0]!.thumbPath!));
// print(status);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Fill out all required fields to upload a new item to the store listing.',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),textAlign: TextAlign.center,),
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

                  item.itemName = itemNameController.text;
                  item.retail = double.parse(retailController.text);
                  item.itemDescription = itemDescription.text;
                  item.amountAvailable = int.parse(amountAvailable.text);

                  if(item.onSale){
                    item.salePrice = double.parse(salePriceController.text);
                  }

                  if(costController.text.isNotEmpty){
                    item.cost = double.parse(costController.text);
                  }

                });


               await itemCatalogFirebase.addItemToCatalog(item,path);

               Navigator.pop(context);
              }, child: Text("Submit Item")),
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
                    Switch(value: item.onSale, onChanged: (value)=>{
                      setState((){
                        item.onSale = value;
                      })
                    }),
                  ],
                ),
              ),

              item.onSale ?
              InputTextFieldWidget(controller: salePriceController, hintText: 'Enter Sale Price',textInputType:TextInputType.numberWithOptions(decimal: true)):
                  const SizedBox(),

              InputTextFieldWidget(controller: costController, hintText: 'Enter Cost for Item',textInputType:TextInputType.numberWithOptions(decimal: true)),

            ],
      );
  }
}
