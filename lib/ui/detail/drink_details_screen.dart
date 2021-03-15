import 'dart:ui';

import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/detail/drink_state.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/theme/colors.dart';
import 'package:bartender/theme/theme_helper.dart';
import 'package:bartender/ui/detail/drink_persistent_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class DrinkDetailsScreen extends StatefulWidget {
  final Drink drink;

  DrinkDetailsScreen(this.drink);

  @override
  _DrinkDetailsScreenState createState() => _DrinkDetailsScreenState();
}

class _DrinkDetailsScreenState extends State<DrinkDetailsScreen> {
  ScrollController _hideButtonController;
  bool _isVisible;

  @override
  void initState() {
    super.initState();
    _getDrinkDetail();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CubitConsumer<DrinkCubit, DrinkState>(
      builder: (context, state) {
        return _buildWidget(state);
      },
      listener: (context, state) {
        if (state is FavoriteSuccess) {
          Flushbar(
            message: BartenderLocalizations.of(context).addedFavorite,
            duration: Duration(seconds: 1),
          )..show(context);
        } else if (state is FavoriteError) {
          Flushbar(
            message: BartenderLocalizations.of(context).errorAddFavorite,
            duration: Duration(seconds: 1),
          )..show(context);
        }
        if (state is RemoveFavoriteSuccess) {
          Flushbar(
            message: BartenderLocalizations.of(context).removedFavorite,
            duration: Duration(seconds: 1),
          )..show(context);
        } else if (state is FavoriteError) {
          Flushbar(
            message: BartenderLocalizations.of(context).errorRemoveFavorite,
            duration: Duration(seconds: 1),
          )..show(context);
        } else {
          return _buildWidget(state);
        }
      },
    ));
  }

  Widget _buildWidget(DrinkState state) {
    if (state is DrinkLoading) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return false;
          },
          child: _buildLoadingWidget(MediaQuery.of(context).orientation));
    } else if (state is DrinkError) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return false;
          },
          child: _buildErrorWidget(MediaQuery.of(context).orientation));
    } else if (state is DrinkSuccess) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, state.isFavorite);
            return false;
          },
          child: _buildSuccessWidget(MediaQuery.of(context).orientation,
              state.drink, state.isFavorite));
    } else if (state is FavoriteSuccess) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: _buildSuccessWidget(
              MediaQuery.of(context).orientation, state.drink, true));
    } else if (state is FavoriteError) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return false;
          },
          child: _buildSuccessWidget(
              MediaQuery.of(context).orientation, state.drink, false));
    }
    if (state is RemoveFavoriteSuccess) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return false;
          },
          child: _buildSuccessWidget(
              MediaQuery.of(context).orientation, state.drink, false));
    } else if (state is FavoriteError) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context, true);
                return false;
              },
              child: _buildSuccessWidget(
                  MediaQuery.of(context).orientation, state.drink, true)));
    } else {
      return Container();
    }
  }

  Widget _buildSuccessWidget(
      Orientation orientation, Drink drink, bool isFavorite) {
    if (orientation == Orientation.portrait) {
      return _buildSuccessWidgetPortrait(drink, isFavorite);
    } else {
      return _buildSuccessWidgetLandscape(drink, isFavorite);
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
        child: Text(text, style: Theme.of(context).textTheme.bodyText1));
  }

  Widget _buildTagWidget(String text, IconData ic) {
    return Padding(
        padding: EdgeInsets.only(top: 12, left: 4, right: 4),
        child: Center(
          child: ClipRect(
            child: Container(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      ic,
                      color: getIt.get<ThemeHelper>().currentTheme ==
                              BartenderTheme.DARK
                          ? Colors.white
                          : Colors.black87,
                      size: 24.0,
                    )),
                Expanded(
                    child: Text(text,
                        style: Theme.of(context).textTheme.bodyText1)),
              ]),
            ),
          ),
        ));
  }

  Widget _buildSuccessWidgetPortrait(Drink drink, bool isFavorite) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: getIt.get<ThemeHelper>().currentTheme ==
                        BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: DrinkPersistentHeader(
                      collapsedHeight: 56,
                      expandedHeight: 300,
                      paddingTop: 4,
                      drink: drink,
                      isFavorite: isFavorite),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Stack(children: [
                        _buildTitleWidget(
                            BartenderLocalizations.of(context).howToMakeLabel),
                      ]),
                      _buildTextWidget(drink.instructions),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).relatedTagsLabel),
                      _buildTagsWidgets(drink),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).servingLabel),
                      _buildTextWidget(
                          BartenderLocalizations.of(context).servingSuggestion),
                    ],
                  ),
                ),
              ],
              controller: _hideButtonController,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: AnimatedOpacity(
            opacity: _isVisible ? 1 : 0,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            child:
                _buildFavoriteButton(Orientation.portrait, drink, isFavorite)));
  }

  Widget _buildSuccessWidgetLandscape(Drink drink, bool isFavorite) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? lightBlueGradient
                  : blueGradient),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Hero(
                    tag: drink.imageURL,
                    child: CachedNetworkImage(
                      height: double.infinity,
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
                  Align(
                      alignment: Alignment.bottomRight,
                      child: _buildFavoriteButton(
                          Orientation.landscape, drink, isFavorite))
                ],
              )),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildTitleWidget(drink.name),
                      _buildTitleWidget(
                          BartenderLocalizations.of(context).howToMakeLabel),
                      _buildTextWidget(drink.instructions),
                      _buildTagsWidgets(drink),
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
        decoration: BoxDecoration(
            gradient:
                getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: widget.drink,
                  isFavorite: false),
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
      decoration: BoxDecoration(
          gradient:
              getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? lightBlueGradient
                  : blueGradient),
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
        decoration: BoxDecoration(
            gradient:
                getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: widget.drink,
                  isFavorite: false),
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
      decoration: BoxDecoration(
          gradient:
              getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? lightBlueGradient
                  : blueGradient),
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
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Widget _buildFavoriteButton(
      Orientation orientation, Drink drink, bool isFavorite) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 16, right: orientation == Orientation.landscape ? 16 : 0),
      child: FloatingActionButton(
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          size: 24,
          color: gradientStartColorDark,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          final cubit = context.cubit<DrinkCubit>();
          if (isFavorite) {
            cubit.removeFavoriteDrink(drink);
          } else {
            cubit.addFavoriteDrink(drink);
          }
        },
      ),
    );
  }
}
