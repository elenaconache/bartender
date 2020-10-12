import 'dart:ui';

import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/detail/drink_state.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/detail/drink_persistent_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

const Color blueTextColor = Color(0xff004861);

class DrinkDetailsScreen extends StatefulWidget {
  final Drink drink;

  DrinkDetailsScreen(this.drink);

  @override
  _DrinkDetailsScreenState createState() => _DrinkDetailsScreenState();
}

class _DrinkDetailsScreenState extends State<DrinkDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _getDrinkDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CubitConsumer<DrinkCubit, DrinkState>(builder: (context, state) {
      return _buildWidget(state);
    }, listener: (context, state) {
      return _buildWidget(state);
    }));
  }

  Widget _buildWidget(DrinkState state) {
    if (state is DrinkLoading) {
      return _buildLoadingWidget(MediaQuery.of(context).orientation);
    } else if (state is DrinkError) {
      return _buildErrorWidget(MediaQuery.of(context).orientation);
    } else if (state is DrinkSuccess) {
      return _buildSuccessWidget(
          MediaQuery.of(context).orientation, state.drink);
    } else {
      return Container();
    }
  }

  Widget _buildSuccessWidget(Orientation orientation, Drink drink) {
    if (orientation == Orientation.portrait) {
      return _buildSuccessWidgetPortrait(drink);
    } else {
      return _buildSuccessWidgetLandscape(drink);
    }
  }

  Widget _buildLoadingWidget(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return _buildLoadingWidgetPortrait();
    } else {
      return _buildLoadingWidgetLandscape();
    }
  }

  Widget _buildErrorWidget(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return _buildErrorWidgetPortrait();
    } else {
      return _buildErrorWidgetLandscape();
    }
  }

  Future<void> _getDrinkDetail() async {
    final drinkCubit = context.cubit<DrinkCubit>();
    drinkCubit.getDrinkData(widget.drink.id);
  }

  Widget _buildTagsWidgets(Drink drink) {
    return Container(
        margin: EdgeInsets.only(top: 12, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTagWidget(drink.alcoholic, Icons.local_hotel),
            _buildTagWidget(drink.glass, Icons.local_bar),
            _buildTagWidget(drink.category, Icons.local_offer),
            _buildTagWidget(drink.mainIngredient, Icons.pie_chart),
          ],
        ));
  }

  Widget _buildTextWidget(String text) {
    return Padding(
        padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
        child: Text(text, style: whiteSmallTextStyle));
  }

  Widget _buildTagWidget(String text, IconData ic) {
    return Padding(
        padding: EdgeInsets.only(top: 8, left: 4, right: 4),
        child: Center(
          child: ClipRect(
            child: Container(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      ic,
                      color: Colors.white,
                      size: 48.0,
                    )),
                Expanded(child: Text(text, style: whiteMediumTextStyle)),
              ]),
            ),
          ),
        ));
  }

  Widget _buildSuccessWidgetPortrait(Drink drink) {
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: drink),
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: _buildTitleWidget(
                      BartenderLocalizations.of(context).relatedTagsLabel),
                ),
                _buildTagsWidgets(drink),
                _buildTitleWidget(
                    BartenderLocalizations.of(context).howToMakeLabel),
                _buildTextWidget(drink.instructions),
                _buildTitleWidget(
                    BartenderLocalizations.of(context).servingLabel),
                _buildTextWidget(
                    BartenderLocalizations.of(context).servingSuggestion),
              ],
            ))
          ],
        ));
  }

  Widget _buildSuccessWidgetLandscape(Drink drink) {
    return Container(
      decoration: BoxDecoration(gradient: blueGradient),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
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
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildTitleWidget(drink.name),
                      _buildTagsWidgets(drink),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).howToMakeLabel),
                      _buildTextWidget(drink.instructions),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).servingLabel),
                      _buildTextWidget(
                          BartenderLocalizations.of(context).servingSuggestion),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildLoadingWidgetPortrait() {
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: widget.drink),
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                _buildTitleWidget(
                    BartenderLocalizations.of(context).servingLabel),
                _buildTextWidget(
                    BartenderLocalizations.of(context).servingSuggestion),
              ],
            ))
          ],
        ));
  }

  Widget _buildLoadingWidgetLandscape() {
    return Container(
      decoration: BoxDecoration(gradient: blueGradient),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Hero(
              tag: widget.drink.imageURL,
              child: CachedNetworkImage(
                imageUrl: widget.drink.imageURL,
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
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildTitleWidget(widget.drink.name),
                      Container(
                          width: double.infinity,
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).servingLabel),
                      _buildTextWidget(
                          BartenderLocalizations.of(context).servingSuggestion),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildErrorWidgetPortrait() {
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: widget.drink),
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.error,
                          color: Colors.redAccent,
                          size: 24.0,
                        )),
                    Expanded(
                        child: Text(
                      BartenderLocalizations.of(context).connectionDetails,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'Poppins',
                          fontSize: 16),
                    )),
                  ]),
                ),
                _buildTitleWidget(
                    BartenderLocalizations.of(context).servingLabel),
                _buildTextWidget(
                    BartenderLocalizations.of(context).servingSuggestion),
              ],
            ))
          ],
        ));
  }

  Widget _buildErrorWidgetLandscape() {
    return Container(
      decoration: BoxDecoration(gradient: blueGradient),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Hero(
              tag: widget.drink.imageURL,
              child: CachedNetworkImage(
                imageUrl: widget.drink.imageURL,
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
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildTitleWidget(widget.drink.name),
                      Padding(
                        padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.error,
                                color: Colors.redAccent,
                                size: 24.0,
                              )),
                          Expanded(
                              child: Text(
                            BartenderLocalizations.of(context)
                                .connectionDetails,
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'Poppins',
                                fontSize: 16),
                          )),
                        ]),
                      ),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).servingLabel),
                      _buildTextWidget(
                          BartenderLocalizations.of(context).servingSuggestion),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildTitleWidget(String s) {
    return Padding(
      padding: EdgeInsets.only(left: 24, top: 24, right: 24),
      child: Text(
        s,
        style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
