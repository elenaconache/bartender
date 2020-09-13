import 'package:meta/meta.dart';

class Category {
  final String name;

  Category({
    @required this.name,
  }) : assert(name != null);

  Category.fromJson(Map jsonMap)
      : assert(jsonMap['strCategory'] != null),
        name = jsonMap['strCategory'];
}
