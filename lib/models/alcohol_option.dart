import 'package:meta/meta.dart';

class AlcoholOption {
  final String name;

  const AlcoholOption({
    @required this.name,
  }) : assert(name != null);

  AlcoholOption.fromJson(Map jsonMap)
      : assert(jsonMap['strAlcoholic'] != null),
        name = jsonMap['strAlcoholic'];
}
