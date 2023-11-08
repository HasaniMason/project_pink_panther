import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';
import 'package:top_tier/Custom%20Data/Enums/CreateAccountStatus.dart';
import 'package:top_tier/Custom%20Data/Enums/SignInStatus.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<Client> getClientViaEmail(String email) async {
    //if user is logged in

    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .where('email', isEqualTo: email)
        .withConverter(
            fromFirestore: Client.fromFireStore,
            toFirestore: (Client client, options) => client.toFireStore())
        .get()
        .then((value) => {
              for (var snap in value.docs) {client = snap.data()}
            });

    return client; //return data
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
    } on FirebaseException catch (e) {
      //print(e);
      if (e.code == 'invalid-email') {
        return SignInStatus.invalidEmail;
      } else if (e.code == 'user-disabled') {
        return SignInStatus.disabled;
      } else if (e.code == 'user-not-found') {
        return SignInStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInStatus.wrongPassword;
      } else {
        return SignInStatus.invalidCred;
      }
    }

    return SignInStatus.success;
  }

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

  ///Sign in with Google. If email exists in database, it will use email to obtain client object from firestore. If it does not exist, client object will be created and stored in firestore
  Future<Client> signInWithGoogle() async {
    //begin interactive process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    //search through database to see if client exists
    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .where('email', isEqualTo: gUser.email)
        .withConverter(
            fromFirestore: Client.fromFireStore,
            toFirestore: (Client client, options) => client.toFireStore());

    //reference document if we need to create a new client in database

    var docSnap = await docRef.get().then((value) async => {
          for (var docSnapshot in value.docs)
            {
              //if email already exists, assign client variable. If item does not exist, no client variable will be return and method continues on


                client = await getClientViaEmail(docSnapshot.data().email),
              //method created above
              print("Client gotten: ${client.email}")
            }
        });

    print("Google User: ${gUser.email}, ${gUser.displayName}");
    print("Google User: ${client.email}, ${client.firstName}");

    await FirebaseAuth.instance
        .signInWithCredential(credential); //sign in user with google

    var uuid = Uuid();
    var uniqueID = uuid.v4();

    final createRef = FirebaseFirestore.instance
        .collection('clients')
        .withConverter(
            fromFirestore: Client.fromFireStore,
            toFirestore: (Client client, options) => client.toFireStore())
        .doc(FirebaseAuth.instance.currentUser!.uid);

    if (client.email == '') {
      //if client is still empty, create client in database
      client.email = gUser.email;
      client.token = '';
      client.birthday = DateTime.now();
      client.activeAccount = true;
      client.admin = false;
      client.phoneNumber = '';
      client.notificationsOn = true;
      client.id = FirebaseAuth.instance.currentUser!.uid;

      //split display name into first and last name client variables (google has it as a whole name)

      var name =
          gUser.displayName!.split(' '); //get first occurrence of a space
      String firstName = name[0].trim();

      String lastName = '';
      if (name.length > 1) {
        //to make sure we don't go beyond scope and cause app to crash
        lastName = name[1].trim();
      }

      //store names in client variable
      client.firstName = firstName;
      client.lastName = lastName;

      await createRef.set(client);
    }

    return client;
  }

  ///Sign in with Apple. If email exists in database, it will use email to obtain client object from firestore. If it does not exist, client object will be created and stored in firestore
  signInWithApple() async {
    final appleProvider = AppleAuthProvider();

    final credential = FirebaseAuth.instance.signInWithProvider(appleProvider);
    // appleProvider.
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();

    user = null;
  }
}
