import 'package:meta/meta.dart';

class Drink {
  final String name;
  final String id;
  final String imageURL;
  final String instructions;
  final String category;
  final String glass;
  final String alcoholic;
  final String mainIngredient;

  Drink(
      {@required this.name,
      @required this.id,
      this.imageURL,
      this.instructions,
      this.category,
      this.glass,
      this.alcoholic,
      this.mainIngredient})
      : assert(name != null),
        assert(id != null);

  Drink.fromJson(Map jsonMap)
      : assert(jsonMap['strDrink'] != null),
        assert(jsonMap['idDrink'] != null),
        name = jsonMap['strDrink'],
        imageURL = jsonMap['strDrinkThumb'],
        id = jsonMap['idDrink'],
        instructions = jsonMap['strInstructions'],
        category = jsonMap['strCategory'],
        glass = jsonMap['strGlass'],
        alcoholic = jsonMap['strAlcoholic'],
        mainIngredient = jsonMap['strIngredient1'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'imageURL': imageURL,
      'instructions': instructions,
      'category': category,
      'glass': glass,
      'alcoholic': alcoholic,
      'mainIngredient': mainIngredient,
    };
  }
}
