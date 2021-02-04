import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/repository/api_repository.dart';
import 'package:bartender/data/repository/database_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

import 'drink_state.dart';

class DrinkCubit extends CubitStream<DrinkState> {
  final ApiRepository apiRepository;
  final DatabaseRepository databaseRepository;

  DrinkCubit({@required this.apiRepository, @required this.databaseRepository})
      : assert(apiRepository != null),
        assert(databaseRepository != null),
        super(DrinkInitial()) {
    emit(DrinkInitial());
  }

  void getDrinkData(String id) async {
    try {
      emit(DrinkLoading());
      final drink = await apiRepository.getDrink(id);
      final isFavorite = await databaseRepository.isFavorite(id);
      emit(DrinkSuccess(drink, isFavorite));
    } catch (e) {
      emit(DrinkError());
    }
  }

  void addFavoriteDrink(Drink drink) async {
    try {
      await databaseRepository.insertFavoriteDrink(drink);
      emit(FavoriteSuccess(drink));
    } catch (e) {
      emit(FavoriteError(drink));
    }
  }

  void removeFavoriteDrink(Drink drink) async {
    try {
      await databaseRepository.deleteDrink(drink.id);
      emit(RemoveFavoriteSuccess(drink));
    } catch (e) {
      emit(RemoveFavoriteError(drink));
    }
  }
}
