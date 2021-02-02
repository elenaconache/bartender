import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:bartender/main.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'login_states.dart';

class LoginCubit extends CubitStream<LoginState> {
  final GoogleSignInRepository repository;

  LoginCubit({@required this.repository})
      : assert(repository != null),
        super(LoginInitial()) {
    emit(LoginEmpty());
  }

  void signIn() async {
    emit(LoginLoading());
    await Firebase.initializeApp();
    repository.handleSignIn().then((value) {
      print(value);
      emit(LoginSuccess(getCurrentUser()));
    }).catchError((e) {
      print(e);
      emit(LoginError());
    });
  }
}
