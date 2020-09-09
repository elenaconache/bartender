import 'package:meta/meta.dart';

import 'category.dart';

class CategoryResponse {
  final List<Category> categories;

  const CategoryResponse({
    @required this.categories,
  }) : assert(categories != null);

  CategoryResponse.fromJson(Map jsonMap)
      : assert(jsonMap['drinks'] != null),
        categories = jsonMap['drinks'];
}
