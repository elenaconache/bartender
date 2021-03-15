import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_states.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/backdrop.dart';
import 'package:bartender/ui/detail/drink_details_screen.dart';
import 'package:bartender/ui/list/drink_tile.dart';
import 'package:bartender/ui/list/filters_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

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
          create: (context) => getIt.get<DrinkCubit>(),
          child: DrinkDetailsScreen(drink),
        );
      }),
    );
  }

  Widget _buildDrinksWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return Container(
          color: Colors.transparent,
          child: GridView.count(
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
    return CubitConsumer<DrinksListCubit, DrinksListState>(
      builder: (context, state) {
        return _buildWidget(state);
      },
      listener: (context, state) {
        return _buildWidget(state);
      },
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
    final listView = Container(
      color: Colors.transparent,
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
        ingredient: null,
        onCategorySelected: _onCategorySelected,
        onIngredientSelected: _onIngredientSelected,
      ),
      backPanel: listView,
      frontTitle: _buildFrontTitle(),
    );
    return _backdrop;
  }

  Widget _buildFrontTitle() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          BartenderLocalizations.of(context).filtersLabel.toUpperCase(),
          style: Theme.of(context).textTheme.headline2,
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
        onCategorySelected: _onCategorySelected,
        onIngredientSelected: _onIngredientSelected,
      ),
      backPanel: listView,
      frontTitle: _buildFrontTitle(),
    );
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
          onCategorySelected: _onCategorySelected,
          onIngredientSelected: _onIngredientSelected,
        ),
        backPanel: Container(),
        frontTitle: _buildFrontTitle(),
      );
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

  void _onIngredientSelected(_ingredientFilter) {
    final drinksCubit = context.cubit<DrinksListCubit>();
    drinksCubit.getFilteredData(ingredient: _ingredientFilter);
  }

  void _onCategorySelected(_categoryFilter) {
    final drinksCubit = context.cubit<DrinksListCubit>();
    drinksCubit.getFilteredData(category: _categoryFilter);
  }

  Widget _buildErrorBackdrop(String ingredient, String category) {
    _backdrop = Backdrop(
      frontPanel: FiltersPanel(
        ingredients: ingredients,
        categories: categories,
        ingredient: null,
        category: null,
        onCategorySelected: _onCategorySelected,
        onIngredientSelected: _onIngredientSelected,
      ),
      backPanel: Container(
          margin: EdgeInsets.only(top: 48),
          child: RefreshIndicator(
            onRefresh: () => _retryLastRequest(ingredient, category),
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
          )),
      frontTitle: _buildFrontTitle(),
    );
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
