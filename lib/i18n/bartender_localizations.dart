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
      'profile_label': 'Profile',
      'stats_label': 'Stats',
      'favorites_label': 'Favorites',
      'logout_label': 'Logout',
      'logout_message': 'Are you sure you want to sign out?',
      'yes': 'Yes',
      'no': 'No',
      'title_welcome': 'Welcome',
      'app_name_bartender': 'Bartender',
      'added_favorite': 'Added to favorites',
      'error_add_favorite': 'Error while adding to favorites',
      'removed_favorite': 'Removed from favorites',
      'error_remove_favorite': 'Error while removing from favorites',
      'title_ingredients_chart': 'Favorite cocktail ingredients',
      'label_unknown': 'Unknown',
      'label_other': 'Other',
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
      'profile_label': 'Profil',
      'stats_label': 'Statistici',
      'favorites_label': 'Favorite',
      'logout_label': 'Deconectare',
      'logout_message': 'Esti sigur ca vrei sa te deconectezi?',
      'yes': 'Da',
      'no': 'Nu',
      'title_welcome': 'Bine ai venit',
      'app_name_bartender': 'Bartender',
      'added_favorite': 'S-a adaugat la favorite',
      'error_add_favorite': 'Eroare la adaugarea in favorite',
      'removed_favorite': 'Eliminat din favorite',
      'error_remove_favorite': 'Eroare la eliminarea din favorite',
      'title_ingredients_chart': 'Ingredientele favorite de cocktail',
      'label_unknown': 'Necunoscut',
      'label_other': 'Altul',
    },
  };

  String get labelUnknown {
    return _localizedValues[locale.languageCode]['label_unknown'];
  }

  String get labelOther {
    return _localizedValues[locale.languageCode]['label_other'];
  }

  String get titleIngredientsChart {
    return _localizedValues[locale.languageCode]['title_ingredients_chart'];
  }

  String get errorRemoveFavorite {
    return _localizedValues[locale.languageCode]['error_remove_favorite'];
  }

  String get removedFavorite {
    return _localizedValues[locale.languageCode]['removed_favorite'];
  }

  String get errorAddFavorite {
    return _localizedValues[locale.languageCode]['error_add_favorite'];
  }

  String get addedFavorite {
    return _localizedValues[locale.languageCode]['added_favorite'];
  }

  String get bartenderAppName {
    return _localizedValues[locale.languageCode]['app_name_bartender'];
  }

  String get titleWelcome {
    return _localizedValues[locale.languageCode]['title_welcome'];
  }

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

  String get profileLabel {
    return _localizedValues[locale.languageCode]['profile_label'];
  }

  String get statsLabel {
    return _localizedValues[locale.languageCode]['stats_label'];
  }

  String get favoritesLabel {
    return _localizedValues[locale.languageCode]['favorites_label'];
  }

  String get logoutLabel {
    return _localizedValues[locale.languageCode]['logout_label'];
  }

  String get logoutMessage {
    return _localizedValues[locale.languageCode]['logout_message'];
  }

  String get yes {
    return _localizedValues[locale.languageCode]['yes'];
  }

  String get no {
    return _localizedValues[locale.languageCode]['no'];
  }
}
