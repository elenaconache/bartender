import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/theme/colors.dart';
import 'package:bartender/theme/theme_helper.dart';
import 'package:bartender/ui/drawer/drawer_screen.dart';
import 'package:bartender/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'blocs/logout/drawer_cubit.dart';
import 'dependency_injection.dart';
import 'i18n/bartender_localization_delegate.dart';

void main() async {
  inject();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getIt.get<ThemeHelper>().getCurrentTheme();

  runApp(BartenderApp());
}

class BartenderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeHelper>(create: (context) {
      return getIt.get<ThemeHelper>();
    }, child: Consumer<ThemeHelper>(builder: (context, model, _) {
      return _buildAppWidget();
    }));
  }

  Widget _buildAppWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bartender',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: getCurrentUser() == null
          ? CubitProvider<LoginCubit>(
              create: (context) => getIt.get<LoginCubit>(),
              child: LoginScreen(),
            )
          : CubitProvider<LogoutCubit>(
              create: (context) => getIt.get<LogoutCubit>(),
              child: DrawerScreen(getCurrentUser()),
            ),
      themeMode: getIt.get<ThemeHelper>().currentTheme == BartenderTheme.DARK
          ? ThemeMode.dark
          : ThemeMode.light,
      localizationsDelegates: [
        BartenderLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ro', ''),
      ],
    );
  }
}

User getCurrentUser() {
  User _user = FirebaseAuth.instance.currentUser;
  return _user;
}
