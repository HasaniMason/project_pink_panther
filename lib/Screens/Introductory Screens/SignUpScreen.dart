import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/Enums/CreateAccountStatus.dart';
import 'package:top_tier/Firebase/ClientFirebase/ClientFirebase.dart';
import 'package:top_tier/Screens/mainScreen.dart';

import '../../Widgets/TextFieldWidgets.dart';
import 'package:uuid/uuid.dart';

//Screen for sign up
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  //create empty client variable
  Client client = Client(
      firstName: '',
      lastName: '',
      email: '',
      birthday: DateTime.now(),
      id: '',
      token: '',
      activeAccount: true,
      admin: false,
      phoneNumber: '',
      notificationsOn: true);

  CreateAccountStatus? status;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ClientFirebase clientFirebase = ClientFirebase();

  @override
  void initState() {
    super.initState();

    var uuid = Uuid();
    client.id = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondary, //change background to secondary color - black
      appBar: AppBar(
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary, //change the appbar to black
      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Create Account',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              textFields()
            ],
          ),
        ),
      ),
    );
  }

  Widget textFields() {
    return Container(
      //decoration for container that contains text fields and buttons
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          //first name text field
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.person_outline,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'First Name',
            textEditingController: firstNameController,
          ),

          //last name text field
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.person_outline,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Last Name',
            textEditingController: lastNameController,
          ),

          //email
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.email_outlined,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Email',
            textEditingController: emailController,
          ),

          //phone number text field
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.phone_outlined,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Phone Number',
            textEditingController: phoneNumberController,
          ),

          //Password text field
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.lock_outline,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Password',
            textEditingController: passwordController,
          ),

          //confirm password field
          TextFieldWithSuffixIcon(
            suffixIcon: Icon(
              Icons.lock_outline,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Confirm Password',
            textEditingController: confirmPasswordController,
          ),

          //visible divider
          const Padding(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Divider(
              color: Colors.grey,
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () async {
              //assign to client variable
              setState(() {
                client.firstName = firstNameController.text;
                client.lastName = lastNameController.text;
                client.email = emailController.text;
                client.phoneNumber = phoneNumberController.text;
              });
              status = await clientFirebase.createUser(client, passwordController.text);
             // clientFirebase.createUserWithLinkToEmail(client);
              if (status == CreateAccountStatus.success){
                if(!mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainScreen(client: client)), (route) => false);
              }
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
