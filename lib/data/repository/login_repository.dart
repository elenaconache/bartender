import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInRepository();

  void checkAlreadySignedIn({Function onAccount, Function onError}) {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        onAccount(account);
      }
    });
    _googleSignIn
        .signInSilently()
        .then((value) => onAccount(value))
        .catchError(onError);
  }

  GoogleSignInAccount getLastLoggedInAccount() {
    return _googleSignIn.currentUser;
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    _googleSignIn.disconnect();
  }
}
