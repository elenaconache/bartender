import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DrawerScreenState extends Equatable {}

class DrawerInitial extends DrawerScreenState {
  @override
  List<Object> get props => [];
}

class DrawerLoading extends DrawerScreenState {
  @override
  List<Object> get props => [];
}

class LogoutFinished extends DrawerScreenState {
  @override
  List<Object> get props => [];
}

/*class AccountLoaded extends DrawerScreenState {
  final FirebaseUser account;
  @override
  List<Object> get props => [account];
  AccountLoaded(this.account);
}*/
