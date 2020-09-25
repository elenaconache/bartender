import 'dart:async';

import 'package:meta/meta.dart';

import 'api/api_client.dart';
import 'models/category.dart';
import 'models/drink.dart';
import 'models/ingredient.dart';

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
