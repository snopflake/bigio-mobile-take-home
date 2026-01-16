import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/testing/app_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/detail/detail_event.dart';
import '../bloc/detail/detail_state.dart';

class DetailPage extends StatelessWidget {
  final int? characterId;
  const DetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    final id = characterId;

    return BlocProvider(
      create: (_) {
        final bloc = sl<DetailBloc>();
        if (id != null) bloc.add(DetailStarted(id));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
        backgroundColor: AppColors.primary, 
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        title: Text(
          'Detail',
          style: AppTextStyles.title.copyWith(
            fontSize: 18.sp,
            color: Colors.white, 
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          BlocBuilder<DetailBloc, DetailState>(
            buildWhen: (p, c) => c is DetailLoaded,
            builder: (context, state) {
              if (state is! DetailLoaded) return const SizedBox.shrink();

              return IconButton(
                key: AppKeys.detailFavoriteButton,
                tooltip: state.isFavorite ? 'Unfavorite' : 'Favorite',
                onPressed: () => context.read<DetailBloc>().add(
                      const DetailFavoriteToggled(),
                    ),
                icon: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white, 
                ),
              );
            },
          ),
        ],
      ),
        body: SafeArea(
          child: BlocListener<DetailBloc, DetailState>(
            listener: (context, state) {
              if (state is DetailLoading) {
                AppLoadingDialog.show(context, message: 'Mengambil detail karakter...');
              } else {
                AppLoadingDialog.hide(context);
              }
            },
            child: Builder(
              builder: (context) {
                if (id == null) {
                  return const _CenteredMessage('Invalid character id');
                }

                return BlocBuilder<DetailBloc, DetailState>(
                  builder: (context, state) {
                    
                    if (state is DetailLoading) {
                      return const SizedBox.shrink();
                    }

                    if (state is DetailError) {
                      return _CenteredMessage(state.message);
                    }

                    if (state is DetailEmpty) {
                      return const _CenteredMessage('Character not found');
                    }

                    if (state is DetailLoaded) {
                      final c = state.character;

                      return ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.network(
                                c.image,
                                key: AppKeys.detailImage,
                                height: 220.w,
                                width: 220.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 220.w,
                                  width: 220.w,
                                  alignment: Alignment.center,
                                  color: Colors.black12,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            c.name,
                            key: AppKeys.detailName,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _InfoTile(label: 'Species', value: c.species),
                          _InfoTile(label: 'Gender', value: c.gender),
                          _InfoTile(label: 'Origin', value: c.origin),
                          _InfoTile(label: 'Location', value: c.location),
                          SizedBox(height: 8.h),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final shown = value.trim().isEmpty ? '-' : value.trim();

    return Container(
      key: AppKeys.detailInfoTile(label),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86.w,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              shown,
              style: AppTextStyles.body.copyWith(fontSize: 14.sp),
            ),
          ),
        ],
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
