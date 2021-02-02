import 'dart:async';

import 'package:bartender/dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  GoogleSignInRepository();

  void checkAlreadySignedIn({Function onAccount, Function onError}) {
   /* getIt
        .get<GoogleSignIn>()
        .onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        onAccount(account);
      }
    });*/
    /*getIt
        .get<GoogleSignIn>()
        .signInSilently()
        .then((value) => onAccount(value))
        .catchError(onError);*/
  }

  /*Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    print("User: ${_user.displayName ?? "None"}");
    return _user;
  }*/

  // Future<User> signInWithGoogle()//
  /* async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }*/
/*  async
  {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await getIt.get<GoogleSignIn>().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    return authResult.user;
  }*/

  void signIn({Function onAccount, Function onError}) async{
   /* try {
      await getIt.get<GoogleSignIn>().signIn();
      GoogleSignInAccount account = getIt.get<GoogleSignIn>().currentUser;
      if (account == null) {
        return null;
      } else {
        return account;
      }
    } catch (error) {
      print(error);
      return null;
    }*/
    await Firebase.initializeApp();
    await getIt.get<GoogleSignIn>().disconnect();
    getIt.get<GoogleSignIn>().onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        // user logged
        //return account;
        onAccount(account);
      } else {
        // user NOT logged
        onError();
      }
    });
    await getIt.get<GoogleSignIn>().signIn()/*.whenComplete(() => dismissLoading())*/;
  }

  Future<void> signOut() async {
    getIt.get<GoogleSignIn>().disconnect();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
//
    final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

}
