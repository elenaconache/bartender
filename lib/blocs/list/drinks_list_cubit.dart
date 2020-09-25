import 'package:bartender/data/bartender_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

import 'drinks_list_states.dart';

class DrinksListCubit extends CubitStream<DrinksListState> {
  final BartenderRepository repository;

  DrinksListCubit({@required this.repository})
      : assert(repository != null),
        super(DrinksListInitial()) {
    getInitialData();
  }

  void getInitialData() async {
    try {
      emit(DrinksListLoading());
      final ingredients = await repository.getIngredients();
      final drinks =
          await repository.getFilteredDrinks(ingredient: ingredients[0].name);
      final categories = await repository.getCategories();
      emit(DrinksInitialListSuccess(drinks, ingredients, categories));
    } catch (e) {
      emit(DrinksListError(null, null));
    }
  }

  void getFilteredData({ingredient, category}) async {
    try {
      emit(DrinksListLoading());
      if (ingredient != null) {
        final drinks =
            await repository.getFilteredDrinks(ingredient: ingredient);
        emit(DrinksFilteredListSuccess(drinks, ingredient, category));
      } else if (category != null) {
        final drinks = await repository.getFilteredDrinks(category: category);
        emit(DrinksFilteredListSuccess(drinks, ingredient, category));
      } else {
        emit(DrinksListError(ingredient = ingredient, category = category));
      }
    } catch (e) {
      emit(DrinksListError(ingredient = ingredient, category = category));
    }
  }
}
