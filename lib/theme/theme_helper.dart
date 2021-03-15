import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:flutter/material.dart';

class ThemeHelper extends ChangeNotifier {
  BartenderTheme currentTheme;

  Future<void> setCurrentTheme(BartenderTheme theme) async {
    this.currentTheme = theme;
    await getIt
        .get<SharedPreferencesRepository>()
        .saveString(keyCurrentTheme, theme.toString());
    notifyListeners();
  }

  void toggleTheme() {
    if (currentTheme == BartenderTheme.LIGHT) {
      currentTheme = BartenderTheme.DARK;
    } else {
      currentTheme = BartenderTheme.LIGHT;
    }
    getIt
        .get<SharedPreferencesRepository>()
        .saveString(keyCurrentTheme, currentTheme.toString());
    notifyListeners();
  }

  Future<BartenderTheme> getCurrentTheme() async {
    if (currentTheme == null) {
      currentTheme = await getIt
                  .get<SharedPreferencesRepository>()
                  .getString(keyCurrentTheme) ==
              BartenderTheme.LIGHT.toString()
          ? BartenderTheme.LIGHT
          : BartenderTheme.DARK;
    }
    return currentTheme;
  }
}
