import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/Enums/CreateAccountStatus.dart';
import 'package:top_tier/Custom%20Data/Enums/SignInStatus.dart';
import 'package:uuid/uuid.dart';

User? user;

class ClientFirebase {
  //still working on it
  void createUserWithLinkToEmail(Client client) {
    print("Client email : ${client.email}");

    var acs = ActionCodeSettings(
      url: 'https://localhost',
      handleCodeInApp: true,
      iOSBundleId: "com.example.TopTier.projectPinkPantherCitex",
      androidPackageName: "com.example.TopTier.project_pink_panther",
    );

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: client.email, actionCodeSettings: acs)
        .catchError(
            (onError) => print("Error sending email verification: $onError "))
        .then((value) => print("Successfully sent email verification"));
  }

  //create an account for user using email and password
  Future<CreateAccountStatus> createUser(Client client, String password) async {
    try {
      //try creating user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: client.email, password: password);

      user = userCredential.user;


      client.id = user!.uid ?? '';

      //create a reference to new client into 'clients' database. Storing with id 'user.id'
      final docRef = FirebaseFirestore.instance
          .collection('clients')
          .withConverter(
          fromFirestore: Client.fromFireStore,
          toFirestore: (Client client, options) => client.toFireStore())
          .doc(user!.uid);

      docRef.set(client);
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        ///return this
        return CreateAccountStatus.weakPassword;
      } else if (e.code == "email-already-in-use") {
        return CreateAccountStatus.emailInUse;
      }
    }

    //return success status if works
    return CreateAccountStatus.success;
  }

  //get client data
  Future<Client> getClient() async {

    //if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {

      final docRef = FirebaseFirestore.instance
          .collection('clients')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
          fromFirestore: Client.fromFireStore,
          toFirestore: (Client client, options) => client.toFireStore());

      final docSnap = await docRef.get(); // get data

      return docSnap.data()!; //return data
    } else {
      //return empty client variable
      return Client(
          firstName: 'Not Signed In',
          lastName: "",
          email: '',
          birthday: DateTime.now(),
          id: '',
          token: '',
          activeAccount: false,
          admin: false,
          phoneNumber: '',
          notificationsOn: true);
    }
  }

  //signIn User
  Future<SignInStatus> signIn(String email, String password) async {

    print('email: $email');
    print("pass: $password");
    try {
      print('here');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);


      print('here');
      user = userCredential.user;

    }on FirebaseException catch (e){


      print(e);
      if(e.code == 'invalid-email'){
        return SignInStatus.invalidEmail;
      }else if(e.code == 'user-disabled'){
        return SignInStatus.disabled;
      }else if(e.code == 'user-not-found'){
        return SignInStatus.userNotFound;
      }else if(e.code == 'wrong-password'){
        return SignInStatus.wrongPassword;
      }
      else{
        return SignInStatus.invalidCred;
      }
    }


    return SignInStatus.success;
  }


  signOut()async{
    await FirebaseAuth.instance.signOut();

    user = null;
  }
}
