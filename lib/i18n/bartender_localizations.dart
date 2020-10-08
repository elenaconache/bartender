import 'package:flutter/cupertino.dart';

class BartenderLocalizations {
  BartenderLocalizations(this.locale);

  final Locale locale;

  static BartenderLocalizations of(BuildContext context) {
    return Localizations.of<BartenderLocalizations>(
        context, BartenderLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'filters_unavailable': 'Filters are currently unavailable.',
      'serving_suggestion':
          'Anything is better served with your friends! Do not forget though that drinking an excessive amount of alcohol might lead to health issues.',
      'related_tags_label': 'Related tags',
      'how_to_make_label': 'How do I make it?',
      'serving_label': 'Serving suggestion',
      'connection_details': 'Check your connection for more details',
      'drinks_label': 'Drinks',
      'filters_label': 'Filters',
      'connection_list':
          'It\'s time to drink some water and check your connection',
      'action_select_option': 'Select an option',
      'ingredient_label': 'Ingredient',
      'category_label': 'Category',
      'action_results': 'Show results',
      'action_login': 'Sign in',
      'bartender_offer':
          'The Bartender will offer you creative drinks ideas. Are you ready to be impressed?',
      'action_google': 'Join with Google',
    },
    'ro': {
      'filters_unavailable': 'Momentan, filtrele nu sunt disponibile.',
      'serving_suggestion':
          'Orice bautura este mai buna servita impreuna cu prietenii tai! Nu uita totusi ca excesul de alcool poate dauna sanatatii.',
      'related_tags_label': 'Etichete',
      'how_to_make_label': 'Cum se prepara?',
      'serving_label': 'Sugestie de servire',
      'connection_details': 'Pentru mai multe detalii, verifica-ti conexiunea',
      'drinks_label': 'Bauturi',
      'filters_label': 'Filtre',
      'connection_list':
          'Este timpul sa bei niste apa si sa iti verifici conexiunea',
      'action_select_option': 'Selecteaza o optiune',
      'ingredient_label': 'Ingredient',
      'category_label': 'Categorie',
      'action_results': 'Vezi rezultatele',
      'action_login': 'Conectare',
      'bartender_offer':
          'Bartender iti va oferi idei creative de bauturi. Esti pregatit sa fii impresionat?',
      'action_google': 'Continua cu Google',
    },
  };

  String get filtersUnavailable {
    return _localizedValues[locale.languageCode]['filters_unavailable'];
  }

  String get servingSuggestion {
    return _localizedValues[locale.languageCode]['serving_suggestion'];
  }

  String get relatedTagsLabel {
    return _localizedValues[locale.languageCode]['related_tags_label'];
  }

  String get howToMakeLabel {
    return _localizedValues[locale.languageCode]['how_to_make_label'];
  }

  String get servingLabel {
    return _localizedValues[locale.languageCode]['serving_label'];
  }

  String get connectionDetails {
    return _localizedValues[locale.languageCode]['connection_details'];
  }

  String get drinksLabel {
    return _localizedValues[locale.languageCode]['drinks_label'];
  }

  String get filtersLabel {
    return _localizedValues[locale.languageCode]['filters_label'];
  }

  String get connectionList {
    return _localizedValues[locale.languageCode]['connection_list'];
  }

  String get actionSelectOption {
    return _localizedValues[locale.languageCode]['action_select_option'];
  }

  String get ingredientLabel {
    return _localizedValues[locale.languageCode]['ingredient_label'];
  }

  String get categoryLabel {
    return _localizedValues[locale.languageCode]['category_label'];
  }

  String get actionResults {
    return _localizedValues[locale.languageCode]['action_results'];
  }

  String get actionLogin {
    return _localizedValues[locale.languageCode]['action_login'];
  }

  String get bartenderOffer {
    return _localizedValues[locale.languageCode]['bartender_offer'];
  }

  String get actionGoogle {
    return _localizedValues[locale.languageCode]['action_google'];
  }
}
