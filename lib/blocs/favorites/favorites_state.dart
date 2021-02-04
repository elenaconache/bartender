import 'package:bartender/data/models/drink.dart';
import 'package:equatable/equatable.dart';

abstract class FavoritesState extends Equatable {}

class FavoritesInitial extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesSuccess extends FavoritesState {
  final List<Drink> drinks;

  @override
  List<Object> get props => [drinks];

  FavoritesSuccess(this.drinks);
}

class FavoritesError extends FavoritesState {
  @override
  List<Object> get props => [];

  FavoritesError();
}
