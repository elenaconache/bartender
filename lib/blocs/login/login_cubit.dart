import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'login_states.dart';

class LoginCubit extends CubitStream<LoginState> {
  final GoogleSignInRepository repository;

  LoginCubit({@required this.repository})
      : assert(repository != null),
        super(LoginInitial()) {
    getInitialData();
  }

  bool _isInitialSignIn = true;

  void getInitialData() async {
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

  void signIn() async {
    try {
      emit(LoginLoading());
      GoogleSignInAccount account = await repository.signIn();
      account == null ? emit(LoginEmpty()) : emit(LoginSuccess(account));
    } catch (e) {
      emit(LoginError());
    }
  }
}
