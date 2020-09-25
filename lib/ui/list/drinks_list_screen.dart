import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_states.dart';
import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/bartender_repository.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:bartender/ui/detail/drink_details_screen.dart';
import 'package:bartender/ui/list/drink_tile.dart';
import 'package:bartender/ui/list/filters_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import '../backdrop.dart';

const Color blueTextColor = Color(0xff004861);

class DrinksListScreen extends StatefulWidget {
  DrinksListScreen();

  @override
  _DrinksListScreenState createState() => _DrinksListScreenState();
}

class _DrinksListScreenState extends State<DrinksListScreen> {
  List<Drink> _drinks = <Drink>[];
  Widget _backdrop;
  List<Ingredient> ingredients = <Ingredient>[];
  List<Category> categories = <Category>[];

  void _onDrinkTap(Drink drink) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CubitProvider<DrinkCubit>(
          create: (context) => DrinkCubit(
              repository: BartenderRepository(apiClient: ApiClient())),
          child: DrinkDetailsScreen(drink),
        );
      }),
    );
  }

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
  }

  Widget _buildWidget(DrinksListState state) {
    if (state is DrinksListLoading) {
      return _buildLoadingWidget();
    } else if (state is DrinksListError) {
      return _buildErrorBackdrop(state.ingredient, state.category);
    } else if (state is DrinksInitialListSuccess) {
      return _buildInitialBackdrop(state);
    } else if (state is DrinksFilteredListSuccess) {
      return _buildFilteredBackdrop(state);
    } else {
      return Container();
    }
  }

  Widget _buildInitialBackdrop(DrinksInitialListSuccess state) {
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
      frontTitle: _buildFrontTitle(),
      backTitle: _buildBackTitle(),
    );
    return _backdrop;
  }

  Widget _buildBackTitle() {
    return Text(
      'Drinks',
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontSize: 20),
    ); //),
  }

  Widget _buildFrontTitle() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          'Filters'.toUpperCase(),
          style: TextStyle(
              color: blueTextColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ));
  }

  Widget _buildFilteredBackdrop(DrinksFilteredListSuccess state) {
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
        frontTitle: _buildFrontTitle(),
        backTitle: _buildBackTitle());
    return _backdrop;
  }

  Widget _buildLoadingWidget() {
    if (_backdrop == null) {
      _backdrop = Backdrop(
          frontPanel: FiltersPanel(
            ingredients: ingredients,
            categories: categories,
            ingredient: null,
            category: null,
          ),
          backPanel: Container(),
          frontTitle: _buildFrontTitle(),
          backTitle: _buildBackTitle());
    }

    return Stack(
      children: [
        _backdrop,
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  Widget _buildErrorBackdrop(String ingredient, String category) {
    _backdrop = Backdrop(
        frontPanel: FiltersPanel(
          ingredients: ingredients,
          categories: categories,
          ingredient: null,
          category: null,
        ),
        backPanel: Container(
            margin: EdgeInsets.only(top: 20),
            child: RefreshIndicator(
              onRefresh: () => _retryLastRequest(ingredient, category),
              child: ListView(
                children: [
                  Image.asset(
                    'assets/images/wine.png',
                    fit: BoxFit.fitWidth,
                  ),
                  Center(
                      child: Text(
                    'No drinks found. Pull to refresh.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ))
                ],
              ),
            )),
        frontTitle: _buildFrontTitle(),
        backTitle: _buildBackTitle());
    return _backdrop;
  }

  Future<void> _retryLastRequest(String ingredient, String category) async {
    final drinksCubit = context.cubit<DrinksListCubit>();
    if (ingredient == null && category == null) {
      drinksCubit.getInitialData();
    } else {
      drinksCubit.getFilteredData(ingredient: ingredient, category: category);
    }
  }
}
