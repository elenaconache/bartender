import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:bartender/main.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'login_states.dart';

class LoginCubit extends CubitStream<LoginState> {
  final GoogleSignInRepository repository;

  LoginCubit({@required this.repository})
      : assert(repository != null),
        super(LoginInitial()) {
    //   getInitialData();
    emit(LoginEmpty());
  }

  bool _isInitialSignIn = true;

  /*void getInitialData() async {
    try {
      emit(LoginLoading());
      repository.checkAlreadySignedIn(onAccount: (account) {
        if (_isInitialSignIn) {
          _isInitialSignIn = false;
          if (account != null) {
            emit(AlreadyLoggedIn(account));
            print(account.toString());
          } else {
            emit(LoginEmpty());
          }
        } else {
          if (account != null) {
            emit(LoginSuccess(account));
            print(account.toString());
          } else {
            emit(LoginError());
          }
        }
      }, onError: (Object exception) {
        print(exception.toString());
        emit(LoginEmpty());
      });
    } catch (e) {
      print(e.toString());
      emit(LoginError());
    }
  }
*/
  void signIn() async {
  /*  try {
    //  emit(LoginLoading());
      repository.signIn(
          onAccount: (GoogleSignInAccount account){
            User currentUser = FirebaseAuth.instance.currentUser;
    /*  if (account.id != currentUser.uid)
      {
        print("error id ${account.id} ${currentUser.uid}");
        emit(LoginError());
      }else{
    print("success");*/
    // credentials== null ? emit(LoginEmpty()) : emit(LoginSuccess(credentials));
  //  }
    }, onError: ()=> {
  //  emit(LoginError())
    });


    } catch (e) {
    print(e);
 //   emit(LoginError());
    }*/

    await Firebase.initializeApp();
    repository.handleSignIn().then((value) => print(value))
        .catchError((e) => print(e));
  }
}
