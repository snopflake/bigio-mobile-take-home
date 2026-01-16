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
                      onRemove: (id) => context
                          .read<FavoritesBloc>()
                          .add(FavoriteRemoved(id)),
                    );
                  }

                  return const SizedBox.shrink();
                },
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
  final void Function(int id) onRemove;

  const _FavoritesGrid({
    required this.favorites,
    required this.onTap,
    required this.onRemove,
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
        return _FavoriteCard(
          key: AppKeys.favoriteCard(c.id),
          character: c,
          onTap: () => onTap(c.id),
          onRemove: () => onRemove(c.id),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: InkWell(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: Text(
                  character.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: Text(
                  '${character.species} - ${character.gender}',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
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
