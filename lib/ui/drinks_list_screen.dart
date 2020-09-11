import 'package:bartender/blocs/drinks_list_cubit.dart';
import 'package:bartender/blocs/drinks_list_states.dart';
import 'package:bartender/data/models/drink.dart';
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
  // Widgets are supposed to be deeply immutable objects. We can update and edit
  // _categories as we build our app, and when we pass it into a widget's
  // `children` property, we call .toList() on it.
  // For more details, see https://github.com/dart-lang/sdk/issues/27755
  List<Drink> _drinks = <Drink>[];

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
      body: CubitBuilder<DrinksListCubit, DrinksListState>(
        builder: (context, state) {
          if (state is DrinksListLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DrinksListError) {
            return Center(
              child: Icon(Icons.close),
            );
          } else if (state is DrinksListSuccess) {
            List<Drink> drinks = state.drinks;
            _drinks = drinks; //todo tabs with the result
            assert(debugCheckHasMediaQuery(context));
            final listView = Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 48.0,
              ),
              child: _buildDrinksWidgets(MediaQuery.of(context).orientation),
            );
            return Backdrop(
              frontPanel: FiltersPanel(
                  ingredients: state.ingredients, categories: state.categories),
              backPanel: listView,
              frontTitle: Text(''),
              backTitle: Text('Drinks'),
            );
          } else {
            return Container();
          }
        },
      ),
    );

    // Based on the device size, figure out how to best lay out the list
    // You can also use MediaQuery.of(context).size to calculate the orientation
  }
}
