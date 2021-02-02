import 'dart:async';

import 'package:bartender/dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  GoogleSignInRepository();

  Future<void> signOut() async {
    getIt.get<GoogleSignIn>().disconnect();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
