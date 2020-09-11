import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:bartender/data/models/alcohol_option.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';

class ApiClient {
  /// We use the `dart:io` HttpClient. More details: https://flutter.io/networking/
  // We specify the type here for readability. Since we're defining a final
  // field, the type is determined at initialization.
  final HttpClient _httpClient = HttpClient();

  final String _baseURL = 'www.thecocktaildb.com';

  Future<List<Drink>> getFilteredDrinks(String alcoholOption,
      {String ingredient, String category}) async {
    final Map<String, String> queryParams = Map();
    queryParams['a'] = alcoholOption;
    if (ingredient != null) {
      queryParams['i'] = ingredient;
    }
    if (category != null) {
      queryParams['c'] = category;
    }
    final uri = Uri.https(_baseURL, '/api/json/v1/1/filter.php', queryParams);
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving filtered drinks.');
      return null;
    }
    final drinks = <Drink>[];
    for (var d in jsonResponse['drinks']) {
      drinks.add(Drink.fromJson(d));
    }
    return drinks;
  }

  Future<List<AlcoholOption>> getAlcoholOptions() async {
    final uri = Uri.https(_baseURL, '/api/json/v1/1/list.php', {'a': 'list'});
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving alcohol options.');
      return null;
    }
    final alcoholOptions = <AlcoholOption>[];
    for (var opt in jsonResponse['drinks']) {
      alcoholOptions.add(AlcoholOption.fromJson(opt));
    }
    return alcoholOptions;
  }

  Future<List<Ingredient>> getIngredients() async {
    final uri = Uri.https(_baseURL, '/api/json/v1/1/list.php', {'i': 'list'});
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving ingredients.');
      return null;
    }
    final ingredients = <Ingredient>[];
    for (var i in jsonResponse['drinks']) {
      ingredients.add(Ingredient.fromJson(i));
    }
    return ingredients;
  }

  Future<List<Category>> getCategories() async {
    final uri = Uri.https(_baseURL, '/api/json/v1/1/list.php', {'c': 'list'});
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving categories.');
      return null;
    }
    final categories = <Category>[];
    for (var c in jsonResponse['drinks']) {
      categories.add(Category.fromJson(c));
    }
    return categories;
  }

  /// Fetches and decodes a JSON object represented as a Dart [Map].
  ///
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
