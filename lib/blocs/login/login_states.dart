import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final GoogleSignInAccount account;

  @override
  List<Object> get props => [account];

  LoginSuccess(this.account);
}

class LoginError extends LoginState {
  @override
  List<Object> get props => [];

  LoginError();
}

class LoginEmpty extends LoginState {
  @override
  List<Object> get props => [];

  LoginEmpty();
}

class AlreadyLoggedIn extends LoginState {
  final GoogleSignInAccount currentAccount;

  @override
  List<Object> get props => [this.currentAccount];

  AlreadyLoggedIn(this.currentAccount);
}
