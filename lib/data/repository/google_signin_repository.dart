import 'dart:async';

import 'package:bartender/dependency_injection.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  GoogleSignInRepository();

  void checkAlreadySignedIn({Function onAccount, Function onError}) {
    getIt
        .get<GoogleSignIn>()
        .onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        onAccount(account);
      }
    });
    getIt
        .get<GoogleSignIn>()
        .signInSilently()
        .then((value) => onAccount(value))
        .catchError(onError);
  }

  Future<GoogleSignInAccount> signIn() async {
    try {
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
    }
  }

  Future<void> signOut() async {
    getIt.get<GoogleSignIn>().disconnect();
  }
}
