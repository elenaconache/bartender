import 'package:bartender/data/models/category.dart';
import 'package:bartender/data/models/ingredient.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta/meta.dart';

const _padding = EdgeInsets.all(16.0);
const _labelColor = Color(0xff3333333);
const _borderColor = Color(0x1500001F);
const _hintColor = Color(0xff000000);
const iconColor = Color(0xff004861);
const _dropdownArrowColor = Color(0xff606262);
const _filterLabelTextStyle = TextStyle(
    color: _labelColor,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16);
const _dropdownOptionTextStyle =
    TextStyle(color: _hintColor, fontSize: 16, fontStyle: FontStyle.normal);
const _hintTextStyle = TextStyle(
  color: _hintColor,
  fontSize: 16,
  fontStyle: FontStyle.italic,
);

class FiltersPanel extends StatefulWidget {
  final List<Ingredient> ingredients;
  final List<Category> categories;
  final String ingredient;
  final String category;
  final onCategorySelected;
  final onIngredientSelected;

  FiltersPanel(
      {@required this.ingredients,
      @required this.categories,
      @required this.ingredient,
      @required this.category,
      @required this.onCategorySelected,
      @required this.onIngredientSelected});

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
            style: _dropdownOptionTextStyle,
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
            style: _dropdownOptionTextStyle,
          ),
        ),
      ));
    }
    setState(() {
      _categoryMenuItems = newItems;
    });
  }

  void _setDefaults() {
    setState(() {
      if (widget.ingredients != null &&
          widget.categories != null &&
          widget.ingredients.isNotEmpty &&
          widget.categories.isNotEmpty) {
        if (widget.ingredient == null && widget.category == null) {
          _ingredientFilter = widget.ingredients[0].name;
          _categoryFilter = null;
        } else {
          _ingredientFilter = widget.ingredient;
          _categoryFilter = widget.category;
        }
      }
    });
  }

  void _updateIngredientFilter(dynamic ingredient) {
    setState(() {
      _ingredientFilter = ingredient;
      _categoryFilter = null;
    });
  }

  void _updateCategoryFilter(dynamic category) {
    setState(() {
      _categoryFilter = category;
      _ingredientFilter = null;
    });
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged,
      List<DropdownMenuItem<String>> values) {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.transparent,
        border: Border.all(
          color: _borderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
            child: DropdownButton<String>(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: _dropdownArrowColor,
              ),
              hint: Text(BartenderLocalizations.of(context).actionSelectOption,
                  style: _hintTextStyle),
              isExpanded: true,
              value: currentValue,
              items: values,
              onChanged: onChanged,
              style: _dropdownOptionTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ingredients == null && widget.categories == null) {
      return _buildErrorWidget();
    }
    return Padding(
        padding: _padding,
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? _buildPortraitWidget()
            : _buildLandscapeWidget());
  }

  void _filter() {
    if (_ingredientFilter == null) {
      widget.onCategorySelected(_categoryFilter);
    } else {
      widget.onIngredientSelected(_ingredientFilter);
    }
  }

  Widget _buildErrorWidget() {
    return SingleChildScrollView(
      child: Container(
        margin: _padding,
        padding: _padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
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
              BartenderLocalizations.of(context).filtersUnavailable,
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

  Widget _buildPortraitWidget() {
    final converter = Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        child: ListView(
          children: [
            Text(BartenderLocalizations.of(context).ingredientLabel,
                style: _filterLabelTextStyle),
            _createDropdown(_ingredientFilter, _updateIngredientFilter,
                _ingredientMenuItems),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                BartenderLocalizations.of(context).categoryLabel,
                style: _filterLabelTextStyle,
              ),
            ),
            _createDropdown(
                _categoryFilter, _updateCategoryFilter, _categoryMenuItems),
            Row(
              children: [
                _buildUndoButton(),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildShowResultsButton(),
                )
              ],
            )
          ],
        ));
    return converter;
  }

  Widget _buildUndoButton() {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 32.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: iconColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(
        icon: Icon(Icons.undo),
        iconSize: 24.0,
        color: iconColor,
        onPressed: _setDefaults,
      ),
    );
  }

  Widget _buildLandscapeWidget() {
    final converter = Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        child: ListView(
          children: [
            _buildFiltersLabelsLandscape(),
            _buildFiltersDropdownsLandscape(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: _buildUndoButton(),
                      )),
                ),
                Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildShowResultsButton(),
                    ))
              ],
            )
          ],
        ));
    return converter;
  }

  Widget _buildShowResultsButton() {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 32, left: 4),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: iconColor)),
        padding: EdgeInsets.only(left: 56, right: 56, top: 16, bottom: 16),
        onPressed: () => {_filter()},
        color: iconColor,
        child: PlatformText(
          BartenderLocalizations.of(context).actionResults,
          style: TextStyle(
              color: Colors.white, fontFamily: 'Poppins', fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildFiltersLabelsLandscape() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(BartenderLocalizations.of(context).ingredientLabel,
              style: _filterLabelTextStyle),
        ),
        Expanded(
          flex: 1,
          child: Text(
            BartenderLocalizations.of(context).categoryLabel,
            style: _filterLabelTextStyle,
          ),
        )
      ],
    );
  }

  Widget _buildFiltersDropdownsLandscape() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: _createDropdown(_ingredientFilter, _updateIngredientFilter,
                _ingredientMenuItems),
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 4),
              child: _createDropdown(
                  _categoryFilter, _updateCategoryFilter, _categoryMenuItems),
            ))
      ],
    );
  }
}
