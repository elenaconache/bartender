import 'package:bartender/data/repository/bartender_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

import 'drink_state.dart';

class DrinkCubit extends CubitStream<DrinkState> {
  final BartenderRepository repository;

  DrinkCubit({@required this.repository})
      : assert(repository != null),
        super(DrinkInitial()) {
    emit(DrinkInitial());
  }

  void getDrinkData(String id) async {
    try {
      emit(DrinkLoading());
      final drink = await repository.getDrink(id);
      emit(DrinkSuccess(drink));
    } catch (e) {
      emit(DrinkError());
    }
  }
}
