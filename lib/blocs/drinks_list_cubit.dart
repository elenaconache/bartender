import 'package:bartender/data/bartender_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

import 'drinks_list_states.dart';

class DrinksListCubit extends CubitStream<DrinksListState> {
  final BartenderRepository repository;

  DrinksListCubit({@required this.repository})
      : assert(repository != null),
        super(DrinksListInitial()) {
    _getInitialData();
  }

  void _getInitialData() async {
    try {
      emit(DrinksListLoading());
      final alcoholOptions = await repository.getAlcoholOptions();
      final drinks = await repository.getFilteredDrinks(alcoholOptions[0].name);
      final ingredients = await repository.getIngredients();
      final categories = await repository.getCategories();
      emit(DrinksListSuccess(alcoholOptions, drinks, ingredients, categories));
    } catch (e) {
      emit(DrinksListError());
    }
  }
}
