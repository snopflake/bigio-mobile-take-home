import 'dart:async';

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
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _ctrl;
  late final SearchBloc _bloc;

  Timer? _debounce;

  static const int _debounceMs = 350;
  static const int _minQueryLen = 2;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);

    _bloc = sl<SearchBloc>();

    final q = widget.initialQuery.trim();
    if (q.isNotEmpty) {
      _bloc.add(SearchRequested(query: q));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onChanged(String value) {
    final q = value.trim();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceMs), () {
      if (!mounted) return;

      if (q.isEmpty) {
        _bloc.add(const SearchCleared());
        return;
      }

      if (q.length < _minQueryLen) {
        _bloc.add(const SearchCleared());
        return;
      }

      _bloc.add(SearchRequested(query: q));
    });
  }

  void _submit(String value) {
    final q = value.trim();
    if (q.isEmpty) {
      _bloc.add(const SearchCleared());
      return;
    }
    _bloc.add(SearchRequested(query: q));
  }

  void _clear() {
    _ctrl.clear();
    _bloc.add(const SearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Search',
            style: AppTextStyles.title.copyWith(fontSize: 18.sp),
          ),
        ),
        body: SafeArea(
          child: BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is SearchLoading) {
                AppLoadingDialog.show(context, message: 'Mencari karakter...');
              } else {
                AppLoadingDialog.hide(context);
              }
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              children: [
                _SearchBar(
                  controller: _ctrl,
                  onChanged: _onChanged,         
                  onSubmitted: _submit,           
                  onTapIcon: () => _submit(_ctrl.text),
                  onClear: _clear,
                ),
                SizedBox(height: 18.h),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {

                    if (state is SearchLoading) return const SizedBox.shrink();

                    if (state is SearchError) {
                      return _CenteredMessage(state.message);
                    }

                    if (state is SearchEmpty) {
                      return _CenteredMessage('No results for "${state.query}"');
                    }

                    if (state is SearchLoaded) {
                      return _CharacterGrid(
                        characters: state.results,
                        onTap: (id) => context.pushNamed(
                          'detail',
                          pathParameters: {'id': '$id'},
                        ),
                      );
                    }

                    return const _CenteredMessage('Type a name to search');
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

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTapIcon;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapIcon,
    required this.onClear,
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
      key: AppKeys.searchField,
      focusNode: _focusNode,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,       // ✅ auto-search typing
      onSubmitted: widget.onSubmitted,   // optional
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search character name',
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
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: AppKeys.searchClearButton,
              tooltip: 'Clear',
              onPressed: widget.onClear,
              icon: Icon(
                Icons.clear,
                size: 18.sp,
                color: _focused ? AppColors.secondary : AppColors.primary,
              ),
            ),
            InkWell(
              onTap: widget.onTapIcon,
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
          ],
        ),
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  final List<Character> characters;
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
