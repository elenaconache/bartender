import 'package:bartender/data/repository/login_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
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
      repository.signIn();
    } catch (e) {
      emit(LoginError());
    }
  }
}
