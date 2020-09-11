import 'package:meta/meta.dart';

class Glass {
  final String name;

  const Glass({
    @required this.name,
  }) : assert(name != null);

  Glass.fromJson(Map jsonMap)
      : assert(jsonMap['strGlass'] != null),
        name = jsonMap['strGlass'];
}
