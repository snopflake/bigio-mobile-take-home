import 'package:flutter/widgets.dart';

class AppKeys {

  // Reusable
  static Key characterCard(int id) => ValueKey('character_card_$id');

  // HomePage Keys
  static const homeSearchField = Key('home_search_field');
  static const homeFavoritesButton = Key('home_favorites_button');

  // DetailPage Keys
  static const detailFavoriteButton = Key('detail_favorite_button');
  static const detailImage = Key('detail_image');
  static const detailName = Key('detail_name');
  static Key detailInfoTile(String label) => ValueKey('detail_info_tile_$label');

   // SearchPage Keys
  static const searchField = Key('search_field');
  static const searchClearButton = Key('search_clear_button');

}
