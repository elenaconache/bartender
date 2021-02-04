import 'package:bartender/data/models/drink.dart';
import 'package:equatable/equatable.dart';

abstract class DrinkState extends Equatable {}

class DrinkInitial extends DrinkState {
  @override
  List<Object> get props => [];
}

class DrinkLoading extends DrinkState {
  @override
  List<Object> get props => [];
}

class DrinkSuccess extends DrinkState {
  final Drink drink;
  final bool isFavorite;

  @override
  List<Object> get props => [drink, isFavorite];

  DrinkSuccess(this.drink, this.isFavorite);
}

class DrinkError extends DrinkState {
  @override
  List<Object> get props => [];

  DrinkError();
}

class FavoriteSuccess extends DrinkState {
  final Drink drink;

  @override
  List<Object> get props => [drink];

  FavoriteSuccess(this.drink);
}

class FavoriteError extends DrinkState {
  final Drink drink;

  @override
  List<Object> get props => [drink];

  FavoriteError(this.drink);
}

class RemoveFavoriteSuccess extends DrinkState {
  final Drink drink;

  @override
  List<Object> get props => [drink];

  RemoveFavoriteSuccess(this.drink);
}

class RemoveFavoriteError extends DrinkState {
  final Drink drink;

  @override
  List<Object> get props => [drink];

  RemoveFavoriteError(this.drink);
}
