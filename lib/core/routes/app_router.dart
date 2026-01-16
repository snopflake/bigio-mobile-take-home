import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/characters/presentation/pages/home_page.dart';
import '../../features/characters/presentation/pages/detail_page.dart';
import '../../features/characters/presentation/pages/favorites_page.dart';
import '../../features/characters/presentation/pages/search_page.dart';

// Routes
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const detail = '/detail/:id';
  static const favorites = '/favorites';
  static const search = '/search';
}

class AppRouter {
  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    routes: [
      /// Home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      /// Detail
      GoRoute(
        path: AppRoutes.detail,
        name: 'detail',
        builder: (context, state) {
          final idParam = state.pathParameters['id'];
          final id = int.tryParse(idParam ?? '');

          return DetailPage(characterId: id);
        },
      ),

      /// Favorites
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),

      /// Search
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) {
          final q = state.uri.queryParameters['q'] ?? '';
          return SearchPage(initialQuery: q);
        },
      ),

    ],

    errorBuilder: (context, state) =>  Scaffold(
      appBar: AppBar(title: const Text('Page not found'),),
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  );
}