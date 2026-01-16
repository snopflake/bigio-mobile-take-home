import 'package:bigio_rick_morty/features/characters/presentation/bloc/favorites_sync/favorites_sync_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/testing/app_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../../domain/entities/character.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../bloc/favorites_sync/favorites_sync_cubit.dart';
import '../widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesBloc>()..add(const FavoritesFetchRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Favorites',
            style: AppTextStyles.title.copyWith(fontSize: 18.sp),
          ),
        ),
        body: SafeArea(
          child: BlocListener<FavoritesBloc, FavoritesState>(
            listener: (context, state) {
              if (state is FavoritesLoading) {
                AppLoadingDialog.show(context, message: 'Memuat favorites...');
              } else {
                AppLoadingDialog.hide(context);
              }
            },
            child: BlocListener<FavoritesSyncCubit, FavoritesSyncState>(
              // setiap favorite IDs berubah -> reload list favorites dari DB
              listener: (context, _) {
                context.read<FavoritesBloc>().add(const FavoritesFetchRequested());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return const SizedBox.shrink();
                    }

                    if (state is FavoritesError) {
                      return _CenteredMessage(state.message);
                    }

                    if (state is FavoritesEmpty) {
                      return const _CenteredMessage(
                        'No favorites yet.\nAdd some from Detail Page ❤️',
                        key: AppKeys.favoritesEmptyText,
                      );
                    }

                    if (state is FavoritesLoaded) {
                      return _FavoritesGrid(
                        favorites: state.favorites,
                        onTap: (id) => context.pushNamed(
                          'detail',
                          pathParameters: {'id': '$id'},
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<Character> favorites;
  final void Function(int id) onTap;

  const _FavoritesGrid({
    required this.favorites,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: AppKeys.favoritesList,
      itemCount: favorites.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final c = favorites[index];

        return CharacterCard(
          key: AppKeys.favoriteCard(c.id),
          character: c,
          onTap: () => onTap(c.id),
        );
      },
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;

  const _CenteredMessage(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
