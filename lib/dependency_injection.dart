import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/repository/bartender_repository.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void inject() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<BartenderRepository>(
      () => BartenderRepository(apiClient: getIt.get<ApiClient>()));
  getIt.registerLazySingleton<GoogleSignInRepository>(
      () => GoogleSignInRepository());
  getIt.registerLazySingleton<DrinkCubit>(
      () => DrinkCubit(repository: getIt.get<BartenderRepository>()));
  getIt.registerLazySingleton<DrinksListCubit>(
      () => DrinksListCubit(repository: getIt.get<BartenderRepository>()));
  getIt.registerLazySingleton<LoginCubit>(
      () => LoginCubit(repository: getIt.get<GoogleSignInRepository>()));
}
