import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

class Api {
  /// We use the `dart:io` HttpClient. More details: https://flutter.io/networking/
  // We specify the type here for readability. Since we're defining a final
  // field, the type is determined at initialization.
  final HttpClient _httpClient = HttpClient();

  final String _baseURL = 'https://www.thecocktaildb.com/api/json/v1/1';

  Future<List> getFilteredDrinks(String alcoholOption,
      {String ingredient, String category}) async {
    final Map queryParams = Map();
    queryParams.putIfAbsent("a", () => alcoholOption);
    if (ingredient != null) {
      queryParams.putIfAbsent("i", () => ingredient);
    }
    if (category != null) {
      queryParams.putIfAbsent("c", () => category);
    }
    final uri = Uri.https(_baseURL, '/filter.php', queryParams);
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving filtered drinks.');
      return null;
    }
    return jsonResponse['drinks'];
  }

  Future<List> getAlcoholOptions() async {
    final uri = Uri.https(_baseURL, '/list.php?a=list');
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving alcohol options.');
      return null;
    }
    return jsonResponse['drinks'];
  }

  Future<List> getIngredients() async {
    final uri = Uri.https(_baseURL, '/list.php?i=list');
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving ingredients.');
      return null;
    }
    return jsonResponse['drinks'];
  }

  Future<List> getCategories() async {
    final uri = Uri.https(_baseURL, '/list.php?c=list');
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['drinks'] == null) {
      print('Error retrieving categories.');
      return null;
    }
    return jsonResponse['drinks'];
  }

  /// Fetches and decodes a JSON object represented as a Dart [Map].
  ///
  /// Returns null if the API server is down, or the response is not JSON.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
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
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
