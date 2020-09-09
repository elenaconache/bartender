import 'package:bartender/models/alcohol_option.dart';
import 'package:meta/meta.dart';

class AlcoholOptionsResponse {
  final List<AlcoholOption> options;

  const AlcoholOptionsResponse({
    @required this.options,
  }) : assert(options != null);

  AlcoholOptionsResponse.fromJson(Map jsonMap)
      : assert(jsonMap['drinks'] != null),
        options = jsonMap['drinks'];
}
