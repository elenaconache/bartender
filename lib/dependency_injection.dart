import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/favorites/favorites_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/logout/drawer_cubit.dart';
import 'package:bartender/blocs/profile/profile_cubit.dart';
import 'package:bartender/blocs/stats/stats_cubit.dart';
import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/repository/api_repository.dart';
import 'package:bartender/data/repository/database_repository.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/theme/theme_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

void inject() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<ApiRepository>(
      () => ApiRepository(apiClient: getIt.get<ApiClient>()));
  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());
  getIt.registerLazySingleton<GoogleSignInRepository>(
      () => GoogleSignInRepository());
  getIt.registerFactory<DrinkCubit>(() => DrinkCubit(
      apiRepository: getIt.get<ApiRepository>(),
      databaseRepository: getIt.get<DatabaseRepository>()));
  getIt.registerFactory<DrinksListCubit>(
      () => DrinksListCubit(repository: getIt.get<ApiRepository>()));
  getIt.registerFactory<LoginCubit>(
      () => LoginCubit(repository: getIt.get<GoogleSignInRepository>()));
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        scopes: <String>[
          'email',
          'https://www.googleapis.com/auth/contacts.readonly'
        ],
      ));
  getIt.registerFactory<LogoutCubit>(
      () => LogoutCubit(repository: getIt.get<GoogleSignInRepository>()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(
      signInRepository: getIt.get<GoogleSignInRepository>(),
      databaseRepository: getIt.get<DatabaseRepository>()));
  getIt.registerFactory<FavoritesCubit>(() =>
      FavoritesCubit(databaseRepository: getIt.get<DatabaseRepository>()));
  getIt.registerFactory<StatsCubit>(
      () => StatsCubit(databaseRepository: getIt.get<DatabaseRepository>()));

  getIt.registerLazySingleton<ThemeHelper>(() => ThemeHelper());
  getIt.registerLazySingleton<SharedPreferencesRepository>(
      () => SharedPreferencesRepository());
}
