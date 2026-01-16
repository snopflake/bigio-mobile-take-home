import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/testing/app_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeFetchRequested()),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeLoading) {
                AppLoadingDialog.show(context, message: 'Mengambil data karakter...');
              } else {
                AppLoadingDialog.hide(context);
              }
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              children: [
                const _Header(),
                SizedBox(height: 14.h),
               _SearchBar(
                  controller: _searchCtrl,
                  onTapSearch: () => context.pushNamed('search'),
                ),
                SizedBox(height: 10.h),
                _FavoritesButton(
                  onTap: () => context.pushNamed('favorites'),
                ),
                SizedBox(height: 18.h),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const SizedBox.shrink();
                    }

                    if (state is HomeError) {
                      return _CenteredMessage(state.message);
                    }

                    if (state is HomeEmpty) {
                      return const _CenteredMessage('No characters found');
                    }

                    if (state is HomeLoaded) {
                      return _CharacterGrid(
                        characters: state.characters,
                        onTap: (id) => context.pushNamed(
                          'detail',
                          pathParameters: {'id': '$id'},
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'MORTY VERSE',
          style: AppTextStyles.title.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explore Morty Verse Characters!',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTapSearch;

  const _SearchBar({
    required this.controller,
    required this.onTapSearch,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: AppKeys.homeSearchField,
      focusNode: _focusNode,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      readOnly: true,
      onTap: widget.onTapSearch,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: AppTextStyles.caption,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 1.4,
          ),
        ),
        suffixIcon: InkWell(
          onTap: widget.onTapSearch,
          splashColor: AppColors.secondary.withValues(alpha: 0.25),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Icon(
              Icons.search,
              size: 18.sp,
              color: _focused ? AppColors.secondary : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FavoritesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: OutlinedButton.icon(
        key: AppKeys.homeFavoritesButton,
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          side: BorderSide(color: Colors.grey.shade300),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
        ),
        icon: Icon(Icons.favorite, size: 18.sp, color: AppColors.primary),
        label: Text(
          'Your favourite character',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  final List<dynamic> characters;
  final void Function(int id) onTap;

  const _CharacterGrid({
    required this.characters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: characters.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final c = characters[index];
        return _CharacterCard(
          key: AppKeys.characterCard(c.id),
          name: c.name,
          subtitle: '${c.species} - ${c.gender}',
          imageUrl: c.image,
          onTap: () => onTap(c.id),
        );
      },
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _CharacterCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AspectRatio(
                  aspectRatio: 1.05,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: Text(
                  name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: Text(
                  subtitle,
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
  const _CenteredMessage(this.message);

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
