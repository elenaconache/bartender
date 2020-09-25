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

  @override
  List<Object> get props => [drink];

  DrinkSuccess(this.drink);
}

class DrinkError extends DrinkState {
  @override
  List<Object> get props => [];

  DrinkError();
}
