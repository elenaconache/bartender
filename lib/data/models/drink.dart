import 'package:meta/meta.dart';

class Drink {
  final String name;
  final String id;
  final String imageURL;
  final String instructions;

  Drink(
      {@required this.name,
      @required this.id,
      this.imageURL,
      this.instructions})
      : assert(name != null),
        assert(id != null);

  Drink.fromJson(Map jsonMap)
      : assert(jsonMap['strDrink'] != null),
        assert(jsonMap['idDrink'] != null),
        name = jsonMap['strDrink'],
        imageURL = jsonMap['strDrinkThumb'],
        id = jsonMap['idDrink'],
        instructions = jsonMap['strInstructions'];
}
