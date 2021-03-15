import 'package:bartender/data/models/drink.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final List<Drink> favoriteDrinks;

  @override
  List<Object> get props => [account, firebaseImageUrl, favoriteDrinks];

  ProfileSuccess(this.account, this.firebaseImageUrl, this.favoriteDrinks);
}

class ProfileError extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileIncomplete extends ProfileState {
  final User account;
  final List<Drink> favoriteDrinks;

  @override
  List<Object> get props => [account, favoriteDrinks];

  ProfileIncomplete(this.account, this.favoriteDrinks);
}

class ProfileEmpty extends ProfileState {
  @override
  List<Object> get props => [];

  ProfileEmpty();
}
