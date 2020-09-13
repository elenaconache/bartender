import 'package:bartender/data/models/drink.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cached_network_image/cached_network_image.dart';

// We use an underscore to indicate that these variables are private.
// See https://www.dartlang.org/guides/language/effective-dart/design#libraries
class DrinkTile extends StatelessWidget {
  final Drink drink;
  final ValueChanged<Drink> onTap;

  DrinkTile({
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
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          //color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            imageUrl: drink.imageURL + "/preview",
            placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0xffe76f51),
            )),
          ),
        ),
      ),
    );
  }
}
