import 'package:meta/meta.dart';

import 'drink.dart';

class DrinksResponse {
  final List<Drink> drinks;

  const DrinksResponse({
    @required this.drinks,
  }) : assert(drinks != null);

  DrinksResponse.fromJson(Map jsonMap)
      : assert(jsonMap['drinks'] != null),
        drinks = jsonMap['drinks'];
}
