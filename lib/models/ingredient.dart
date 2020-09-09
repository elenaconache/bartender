import 'package:meta/meta.dart';

class Ingredient {
  final String name;

  const Ingredient({
    @required this.name,
  }) : assert(name != null);

  Ingredient.fromJson(Map jsonMap)
      : assert(jsonMap['strIngredient1'] != null),
        name = jsonMap['strIngredient1'];
}
