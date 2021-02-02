import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileSuccess extends ProfileState {
  final User account;
  final String firebaseImageUrl;

  @override
  List<Object> get props => [account, firebaseImageUrl];

  ProfileSuccess(this.account, this.firebaseImageUrl);
}

class ProfileError extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileIncomplete extends ProfileState {
  final User account;

  @override
  List<Object> get props => [account];

  ProfileIncomplete(this.account);
}

class ProfileEmpty extends ProfileState {
  @override
  List<Object> get props => [];

  ProfileEmpty();
}
