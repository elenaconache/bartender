import 'package:bartender/data/models/drink.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrinkPersistentHeader extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;

  final Drink drink;

  DrinkPersistentHeader(
      {this.collapsedHeight, this.expandedHeight, this.paddingTop, this.drink});

  @override
  double get minExtent => this.collapsedHeight;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(100, 255)
        .toInt();
    int color = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, color, color, color);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 72, 97); //<=> start gradient color
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Hero(
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
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
                color: this.makeStickyHeaderBgColor(shrinkOffset),
                // Background color
                child: SafeArea(
                  bottom: false,
                  child: Container(
                      width: double.infinity,
                      height: this.collapsedHeight,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 24,
                              color: this.makeStickyHeaderTextColor(
                                  shrinkOffset, true), // Return icon color
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(right: 48),
                                  child: Center(
                                      child: Text(
                                    drink.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: this.makeStickyHeaderTextColor(
                                            shrinkOffset, true),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ))))
                        ],
                      )),
                )),
          ),
        ],
      ),
    );
  }
}
