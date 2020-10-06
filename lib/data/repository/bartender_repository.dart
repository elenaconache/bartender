import 'dart:async';

import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:meta/meta.dart';

class BartenderRepository {
  final ApiClient apiClient;

  BartenderRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<List<Drink>> getFilteredDrinks(
      {String ingredient, String category}) async {
    return apiClient.getFilteredDrinks(
        ingredient: ingredient, category: category);
  }

  Future<List<Ingredient>> getIngredients() async {
    return apiClient.getIngredients();
  }

  Future<List<Category>> getCategories() async {
    return apiClient.getCategories();
  }

  Future<Drink> getDrink(String id) async {
    return apiClient.getDrink(id);
  }
}
