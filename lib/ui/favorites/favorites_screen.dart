import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/favorites/favorites_cubit.dart';
import 'package:bartender/blocs/favorites/favorites_state.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/detail/drink_details_screen.dart';
import 'package:bartender/ui/list/drink_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen();

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Drink> _drinks = <Drink>[];

  Future<void> _onDrinkTap(Drink drink) async {
    bool isFavorite = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CubitProvider<DrinkCubit>(
          create: (context) => getIt.get<DrinkCubit>(),
          child: DrinkDetailsScreen(drink),
        );
      }),
    );
    if (!isFavorite) {
      _retryLastRequest();
    }
  }

  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  Widget _buildDrinksWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            padding: EdgeInsets.only(bottom: 48),
            crossAxisCount: 2,
            children: _drinks.map((Drink d) {
              return DrinkTile(
                drink: d,
                onTap: _onDrinkTap,
              );
            }).toList(),
          ));
    } else {
      return GridView.count(
        crossAxisCount: 4,
        children: _drinks.map((Drink d) {
          return DrinkTile(
            drink: d,
            onTap: _onDrinkTap,
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return _buildWidget(state);
      },
      listener: (context, state) {
        return _buildWidget(state);
      },
    );
  }

  Widget _buildWidget(FavoritesState state) {
    if (state is FavoritesLoading || state is FavoritesInitial) {
      return _buildLoadingWidget();
    } else if (state is FavoritesError) {
      return _buildErrorWidget();
    } else if (state is FavoritesSuccess) {
      return _buildSuccessWidget(state.drinks);
    } else {
      return Container();
    }
  }

  Widget _buildSuccessWidget(List<Drink> drinks) {
    _drinks = drinks;
    assert(debugCheckHasMediaQuery(context));
    final listView = Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: _buildDrinksWidgets(MediaQuery.of(context).orientation),
    );
    return RefreshIndicator(
        onRefresh: () => _retryLastRequest(), child: listView);
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
        margin: EdgeInsets.only(top: 48),
        child: RefreshIndicator(
          onRefresh: () => _retryLastRequest(),
          child: ListView(
            children: [
              Image.asset(
                'assets/images/waterglass.png',
                fit: BoxFit.fitHeight,
                height: 160,
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Text(
                  BartenderLocalizations.of(context).connectionList,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  Future<void> _retryLastRequest() async {
    final cubit = context.cubit<FavoritesCubit>();
    cubit.getFavoriteDrinks();
  }
}
