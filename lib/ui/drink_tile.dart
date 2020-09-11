import 'package:bartender/data/models/drink.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
const _rowHeight = 120.0;

class DrinkTile extends StatelessWidget {
  final Drink drink;
  final ValueChanged<Drink> onTap;

  const DrinkTile({
    Key key,
    @required this.drink,
    this.onTap,
  })  : assert(drink != null),
        super(key: key);

  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.network(drink.imageURL),
        ),
      ),
    );
  }
}
