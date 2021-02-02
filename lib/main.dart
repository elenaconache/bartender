import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/ui/drawer/drawer_screen.dart';
import 'package:bartender/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/logout/drawer_cubit.dart';
import 'dependency_injection.dart';
import 'i18n/bartender_localization_delegate.dart';

void main() {
  inject();
  runApp(BartenderApp());
}

class BartenderApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return /*FutureBuilder(
      future: getUserAndInitialize(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){*/
             _buildAppWidget();
       /*   }else{
            return CircularProgressIndicator();
         }
        },
    );*/
  }

  Widget _buildAppWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bartender',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:/* getCurrentUser() == null ?*/ CubitProvider<LoginCubit>(
        create: (context) => getIt.get<LoginCubit>(),
        child: LoginScreen(),
      ) /*: CubitProvider<LogoutCubit>(
        create: (context) => getIt.get<LogoutCubit>(),
        child: DrawerScreen(getCurrentUser()),
      )*/,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        BartenderLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('ro', ''),
      ],
    );
  }


}

User getCurrentUser()  {
  User _user = FirebaseAuth.instance.currentUser;
  //print("User: ${_user.displayName ?? "None"}");
  return _user;
}

Future<User> getUserAndInitialize() async  {
  await Firebase.initializeApp();
  User _user = FirebaseAuth.instance.currentUser;
  //print("User: ${_user.displayName ?? "None"}");
  return _user;
}
