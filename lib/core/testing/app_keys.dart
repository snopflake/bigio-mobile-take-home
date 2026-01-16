import 'package:flutter/widgets.dart';

class AppKeys {
  static const homeSearchField = Key('home_search_field');
  static const homeFavoritesButton = Key('home_favorites_button');

  static Key characterCard(int id) => ValueKey('character_card_$id');
}
