import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Widgets/InputTextFieldWidgets.dart';

import '../../Firebase/Firebase/ClientFirebase.dart';



class AddressSettingsScreen extends StatefulWidget {
  Client client;

  AddressSettingsScreen({required this.client});

  @override
  State<AddressSettingsScreen> createState() => _AddressSettingsScreenState();
}

class _AddressSettingsScreenState extends State<AddressSettingsScreen> {

  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();

  ClientFirebase clientFirebase = ClientFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Text('My Address',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Theme.of(context).primaryColor))
              ],
            ),


            InputFields(),

            Column(
              children: [
                Text("Current Address",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),

                Text("${widget.client.addressLine1 ?? "No Street Address Entered"}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Text("${widget.client.addressLine2?? ""}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Text("${widget.client.city?? "No City Entered"}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Text("${widget.client.state?? "No State Entered"}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Text("${widget.client.zipCode?? "No Zip Code Entered"}",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),

              ],
            )
          ],
        ),
      ),
    );
  }

  Column InputFields() {
    return Column(
          children: [
            InputTextFieldWidget(controller: addressLine1, hintText: 'Address Line 1', textInputType: TextInputType.streetAddress),
            InputTextFieldWidget(controller: addressLine2, hintText: 'Address Line 2', textInputType: TextInputType.streetAddress),
            InputTextFieldWidget(controller: city, hintText: 'City', textInputType: TextInputType.text),
            InputTextFieldWidget(controller: state, hintText: 'State', textInputType: TextInputType.streetAddress),
            InputTextFieldWidget(controller: zipCode, hintText: 'Zip Code', textInputType: TextInputType.number),

            ElevatedButton(onPressed: (){

              setState(() {
                if(addressLine1.text.isNotEmpty){
                  widget.client.addressLine1 = addressLine1.text;
                }
                if(addressLine2.text.isNotEmpty){
                  widget.client.addressLine2 = addressLine2.text;
                }
                if(city.text.isNotEmpty){
                  widget.client.city = city.text;
                }
                if(state.text.isNotEmpty){
                  widget.client.state = state.text;
                }
                if(zipCode.text.isNotEmpty){
                  widget.client.zipCode = zipCode.text;
                }
              });

              clientFirebase.updateAddress(widget.client);

            }, child: Text('Update'))

          ],
        );
  }
}
