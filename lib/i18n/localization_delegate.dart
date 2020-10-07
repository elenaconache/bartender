import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'localizations.dart';

class BartenderLocalizationsDelegate
    extends LocalizationsDelegate<BartenderLocalizations> {
  const BartenderLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ro'].contains(locale.languageCode);

  @override
  Future<BartenderLocalizations> load(Locale locale) {
    return SynchronousFuture<BartenderLocalizations>(
        BartenderLocalizations(locale));
  }

  @override
  bool shouldReload(BartenderLocalizationsDelegate old) => false;
}
