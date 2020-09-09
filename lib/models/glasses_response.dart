import 'package:meta/meta.dart';

import 'glass.dart';

class GlassesResponse {
  final List<Glass> glasses;

  const GlassesResponse({
    @required this.glasses,
  }) : assert(glasses != null);

  GlassesResponse.fromJson(Map jsonMap)
      : assert(jsonMap['drinks'] != null),
        glasses = jsonMap['drinks'];
}
