import 'package:bartender/data/models/drink.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap(drink);
        },
        child: Container(
          margin: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Hero(
              tag: drink.imageURL,
              child: CachedNetworkImage(
                imageUrl: drink.imageURL,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
