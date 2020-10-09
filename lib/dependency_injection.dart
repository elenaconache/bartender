import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/logout/logout_cubit.dart';
import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/repository/bartender_repository.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

void inject() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<BartenderRepository>(
      () => BartenderRepository(apiClient: getIt.get<ApiClient>()));
  getIt.registerLazySingleton<GoogleSignInRepository>(
      () => GoogleSignInRepository());
  getIt.registerFactory<DrinkCubit>(
      () => DrinkCubit(repository: getIt.get<BartenderRepository>()));
  getIt.registerFactory<DrinksListCubit>(
      () => DrinksListCubit(repository: getIt.get<BartenderRepository>()));
  getIt.registerFactory<LoginCubit>(
      () => LoginCubit(repository: getIt.get<GoogleSignInRepository>()));
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      ));
  getIt.registerFactory<LogoutCubit>(
      () => LogoutCubit(repository: getIt.get<GoogleSignInRepository>()));
}
