import 'package:bartender/data/models/alcohol_option.dart';
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

class DrinksListSuccess extends DrinksListState {
  final List<AlcoholOption> alcoholOptions;
  final List<Drink> drinks;
  final List<Ingredient> ingredients;
  final List<Category> categories;

  @override
  List<Object> get props => [alcoholOptions, drinks, ingredients, categories];

  DrinksListSuccess(
      this.alcoholOptions, this.drinks, this.ingredients, this.categories);
}

class DrinksListError extends DrinksListState {
  @override
  List<Object> get props => [];
}
