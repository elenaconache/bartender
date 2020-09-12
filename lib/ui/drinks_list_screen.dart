import 'package:bartender/blocs/drinks_list_cubit.dart';
import 'package:bartender/blocs/drinks_list_states.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:bartender/ui/drink_tile.dart';
import 'package:bartender/ui/filters_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'backdrop.dart';

class DrinksListScreen extends StatefulWidget {
  const DrinksListScreen();

  @override
  _DrinksListScreenState createState() => _DrinksListScreenState();
}

class _DrinksListScreenState extends State<DrinksListScreen> {
  List<Drink> _drinks = <Drink>[];
  Widget _backdrop;
  List<Ingredient> ingredients = <Ingredient>[];
  List<Category> categories = <Category>[];

  void _onDrinkTap(Drink drink) {}

  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  Widget _buildDrinksWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return GridView.count(
        crossAxisCount: 2,
        children: _drinks.map((Drink d) {
          return DrinkTile(
            drink: d,
            onTap: _onDrinkTap,
          );
        }).toList(),
      );
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
    return Scaffold(
      body: CubitConsumer<DrinksListCubit, DrinksListState>(
        builder: (context, state) {
          return _buildWidget(state);
        },
        listener: (context, state) {
          return _buildWidget(state);
        },
      ),
    );

    // Based on the device size, figure out how to best lay out the list
    // You can also use MediaQuery.of(context).size to calculate the orientation
  }

  Widget _buildWidget(DrinksListState state) {
    if (state is DrinksListLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is DrinksListError) {
      return Center(
        child: Icon(Icons.close),
      );
    } else if (state is DrinksInitialListSuccess) {
      List<Drink> drinks = state.drinks;
      _drinks = drinks;
      assert(debugCheckHasMediaQuery(context));
      final listView = Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0,
        ),
        child: _buildDrinksWidgets(MediaQuery.of(context).orientation),
      );
      ingredients = state.ingredients;
      categories = state.categories;

      _backdrop = Backdrop(
        frontPanel: FiltersPanel(
            ingredients: ingredients,
            categories: categories,
            category: null,
            ingredient: null),
        backPanel: listView,
        frontTitle: Text(''),
        backTitle: Text('Drinks'),
      );
      return _backdrop;
    } else if (state is DrinksFilteredListSuccess) {
      List<Drink> drinks = state.drinks;
      _drinks = drinks;
      assert(debugCheckHasMediaQuery(context));
      final listView = Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0,
        ),
        child: _buildDrinksWidgets(MediaQuery.of(context).orientation),
      );

      _backdrop = Backdrop(
        frontPanel: FiltersPanel(
          ingredients: ingredients,
          categories: categories,
          ingredient: state.ingredient,
          category: state.category,
        ),
        backPanel: listView,
        frontTitle: Text(''),
        backTitle: Text('Drinks'),
      );
      return _backdrop;
    } else {
      return Container();
    }
  }
}
