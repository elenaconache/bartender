import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';

class ApiClient {
  final HttpClient _httpClient = HttpClient();

  final String _baseURL = 'www.thecocktaildb.com';

  Future<List<Drink>> getFilteredDrinks(
      {String ingredient, String category}) async {
    final Map<String, String> queryParams = Map();
    if (ingredient != null) {
      queryParams['i'] = ingredient;
    } else if (category != null) {
      queryParams['c'] = category;
    }
    var response =
        await callApi('/api/json/v1/1/filter.php', queryParams, 'drinks');
    if (response != null) {
      final drinks = <Drink>[];
      for (var d in response) {
        drinks.add(Drink.fromJson(d));
      }
      return drinks;
    } else {
      return null;
    }
  }

  Future<List<Ingredient>> getIngredients() async {
    var response =
        await callApi('/api/json/v1/1/list.php', {'i': 'list'}, 'drinks');
    if (response != null) {
      final ingredients = <Ingredient>[];
      for (var i in response) {
        ingredients.add(Ingredient.fromJson(i));
      }
      return ingredients;
    } else {
      return null;
    }
  }

  Future<List<Category>> getCategories() async {
    var response =
        await callApi('/api/json/v1/1/list.php', {'c': 'list'}, 'drinks');
    if (response != null) {
      final categories = <Category>[];
      for (var c in response) {
        categories.add(Category.fromJson(c));
      }
      return categories;
    } else {
      return null;
    }
  }

  Future<Drink> getDrink(String id) async {
    var response =
        await callApi('/api/json/v1/1/lookup.php', {'i': id}, 'drinks');
    if (response != null) {
      return Drink.fromJson(response[0]);
    } else {
      return null;
    }
  }

  Future<dynamic> callApi(
      String path, Map<String, String> params, String responseKey) async {
    final uri = Uri.https(_baseURL, path, params);
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse[responseKey] == null) {
      print('Api call error');
      return null;
    }
    return jsonResponse[responseKey];
  }

  /// Fetches and decodes a JSON object represented as a Dart [Map].
  /// Returns null if the API server is down, or the response is not JSON.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final httpRequest = await _httpClient.getUrl(uri);
    final httpResponse = await httpRequest.close();
    if (httpResponse.statusCode != HttpStatus.ok) {
      return null;
    }
    // The response is sent as a Stream of bytes that we need to convert to a
    // `String`.
    final responseBody = await httpResponse.transform(utf8.decoder).join();
    // Finally, the string is parsed into a JSON object.
    return json.decode(responseBody);
  }
}
