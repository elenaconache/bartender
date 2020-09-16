import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:equatable/equatable.dart';

abstract class DrinksListState extends Equatable {}

class DrinksListInitial extends DrinksListState {
  @override
  List<Object> get props => [];
}

class DrinksListLoading extends DrinksListState {
  @override
  List<Object> get props => [];
}

class DrinksInitialListSuccess extends DrinksListState {
  final List<Drink> drinks;
  final List<Ingredient> ingredients;
  final List<Category> categories;

  @override
  List<Object> get props => [drinks, ingredients, categories];

  DrinksInitialListSuccess(this.drinks, this.ingredients, this.categories);
}

class DrinksListError extends DrinksListState {
  final String ingredient;
  final String category;

  @override
  List<Object> get props => [ingredient, category];

  DrinksListError(this.ingredient, this.category);
}

class DrinksFilteredListSuccess extends DrinksListState {
  final List<Drink> drinks;
  final String ingredient;
  final String category;

  @override
  List<Object> get props => [drinks, ingredient, category];

  DrinksFilteredListSuccess(this.drinks, this.ingredient, this.category);
}
