import 'package:bartender/blocs/stats/stats_state.dart';
import 'package:bartender/data/repository/database_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

const unknown = "keyUnknown";
const other = "keyOther";

class StatsCubit extends CubitStream<StatsState> {
  final DatabaseRepository databaseRepository;

  StatsCubit({@required this.databaseRepository})
      : assert(databaseRepository != null),
        super(StatsInitial()) {
    emit(StatsLoading());
    getIngredientPercent();
  }

  void getIngredientPercent() async {
    try {
      Map<String, double> ingredientFrequency = Map();
      int total = 0;
      List<Map<String, dynamic>> map =
          await databaseRepository.getIngredientFrequencies();
      map.forEach((element) {
        total += element.entries.elementAt(1).value;
        ingredientFrequency.putIfAbsent(element.entries.elementAt(0).value,
            () => (element.entries.elementAt(1).value as int).toDouble());
      });

      ingredientFrequency.forEach((key, value) {
        ingredientFrequency[key] = value * 100 / total;
        print('$key ${value * 100 / total}');
      });
      if (ingredientFrequency.entries.length == 0) {
        ingredientFrequency[unknown] = 100;
        emit(StatsSuccess(ingredientFrequency));
      } else if (ingredientFrequency.entries.length >= 10) {
        var correctedMap = Map<String, double>();
        var totalOthers = 0.0;
        for (int index = 0;
            index < ingredientFrequency.entries.length;
            index++) {
          if (index < 10) {
            correctedMap.putIfAbsent(
                ingredientFrequency.entries.elementAt(index).key,
                () => ingredientFrequency.entries.elementAt(index).value);
          } else {
            totalOthers += ingredientFrequency.entries.elementAt(index).value;
          }
        }
        correctedMap.putIfAbsent(other, () => totalOthers);
        emit(StatsSuccess(correctedMap));
      } else {
        emit(StatsSuccess(ingredientFrequency));
      }
    } catch (e) {
      print(e.toString());
      emit(StatsError());
    }
  }
}
