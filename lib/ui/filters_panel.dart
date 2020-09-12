import 'package:bartender/blocs/drinks_list_cubit.dart';
import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta/meta.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

const _padding = EdgeInsets.all(16.0);

class FiltersPanel extends StatefulWidget {
  final List<Ingredient> ingredients;
  final List<Category> categories;
  final String ingredient;
  final String category;

  const FiltersPanel(
      {@required this.ingredients,
      @required this.categories,
      @required this.ingredient,
      @required this.category});

  @override
  _FiltersPanelState createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  List<DropdownMenuItem<String>> _ingredientMenuItems;
  List<DropdownMenuItem<String>> _categoryMenuItems;
  String _ingredientFilter, _categoryFilter;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem<String>>[];
    for (var ingredient in widget.ingredients) {
      newItems.add(DropdownMenuItem<String>(
        value: ingredient.name,
        child: Container(
          child: Text(
            ingredient.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _ingredientMenuItems = newItems;
    });
    newItems = <DropdownMenuItem<String>>[];
    for (var category in widget.categories) {
      newItems.add(DropdownMenuItem<String>(
        value: category.name,
        child: Container(
          child: Text(
            category.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _categoryMenuItems = newItems;
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _ingredientFilter = widget.ingredient == null
          ? widget.ingredients[0].name
          : widget.ingredient;
      _categoryFilter =
          widget.category == null ? widget.categories[0].name : widget.category;
    });
  }

  void _updateIngredientFilter(dynamic ingredient) {
    setState(() {
      _ingredientFilter = ingredient;
    });
  }

  void _updateCategoryFilter(dynamic category) {
    setState(() {
      _categoryFilter = category;
    });
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged,
      List<DropdownMenuItem<String>> values) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              isExpanded: true,
              value: currentValue,
              items: values,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ingredients == null && widget.categories == null) {
      return SingleChildScrollView(
        child: Container(
          margin: _padding,
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 180.0,
                color: Colors.white,
              ),
              Text(
                "Filters are currently unavailable.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final ingredientInput = Padding(
        padding: EdgeInsets.all(4.0),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ingredient',
                textWidthBasis: TextWidthBasis.parent,
                style: Theme.of(context).textTheme.headline6,
              ),
              _createDropdown(_ingredientFilter, _updateIngredientFilter,
                  _ingredientMenuItems),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: PlatformButton(
                  onPressed: () => {_onIngredientSelected()},
                  color: Colors.blueGrey,
                  child: PlatformText(
                    'Show results',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
    final categoryInput = IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Category',
            textWidthBasis: TextWidthBasis.parent,
            style: Theme.of(context).textTheme.headline6,
          ),
          _createDropdown(
              _categoryFilter, _updateCategoryFilter, _categoryMenuItems),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: PlatformButton(
              onPressed: () => {_onCategorySelected()},
              color: Colors.blueGrey,
              child: PlatformText(
                'Show results',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );

    final converter = ListView(
      children: [
        ingredientInput,
        categoryInput,
      ],
    );
    // Based on the orientation of the parent widget, figure out how to best
    // lay out our converter.
    return Padding(
      padding: _padding,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return converter;
          } else {
            return SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ingredientInput,
                  ),
                  Expanded(
                    flex: 1,
                    child: categoryInput,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onIngredientSelected() {
    final drinksCubit = context.cubit<DrinksListCubit>();
    drinksCubit.getFilteredData(ingredient: _ingredientFilter);
  }

  void _onCategorySelected() {
    final drinksCubit = context.cubit<DrinksListCubit>();
    drinksCubit.getFilteredData(category: _categoryFilter);
  }
}
