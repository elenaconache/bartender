import 'package:bartender/models/ingredient.dart';
import 'package:meta/meta.dart';

class IngredientsResponse {
  final List<Ingredient> ingredients;

  const IngredientsResponse({
    @required this.ingredients,
  }) : assert(ingredients != null);

  IngredientsResponse.fromJson(Map jsonMap)
      : assert(jsonMap['drinks'] != null),
        ingredients = jsonMap['drinks'];
}
