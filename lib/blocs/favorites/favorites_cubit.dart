import 'package:bartender/blocs/favorites/favorites_state.dart';
import 'package:bartender/data/repository/database_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

class FavoritesCubit extends CubitStream<FavoritesState> {
  final DatabaseRepository databaseRepository;

  FavoritesCubit({@required this.databaseRepository})
      : assert(databaseRepository != null),
        super(FavoritesInitial()) {
    emit(FavoritesLoading());
    getFavoriteDrinks();
  }

  void getFavoriteDrinks() async {
    try {
      var drinks = await databaseRepository.getFavoriteDrinks();
      emit(FavoritesSuccess(drinks));
    } catch (e) {
      emit(FavoritesError());
    }
  }
}
