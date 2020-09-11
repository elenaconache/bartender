import 'dart:async';

import 'package:meta/meta.dart';

import 'api/api_client.dart';
import 'models/alcohol_option.dart';
import 'models/category.dart';
import 'models/drink.dart';
import 'models/ingredient.dart';

class BartenderRepository {
  final ApiClient apiClient;

  BartenderRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<List<Drink>> getFilteredDrinks(String alcoholOption,
      {String ingredient, String category}) async {
    return apiClient.getFilteredDrinks(alcoholOption,
        ingredient: ingredient, category: category);
  }

  Future<List<AlcoholOption>> getAlcoholOptions() async {
    return apiClient.getAlcoholOptions();
  }

  Future<List<Ingredient>> getIngredients() async {
    return apiClient.getIngredients();
  }

  Future<List<Category>> getCategories() async {
    return apiClient.getCategories();
  }
}
