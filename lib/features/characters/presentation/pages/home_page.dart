import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeFetchRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Characters', style: AppTextStyles.title),
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoading) {
              AppLoadingDialog.show(
                context,
                message: 'Mengambil data karakter...',
              );
            } else {
              AppLoadingDialog.hide(context);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const SizedBox.shrink();
              }

              if (state is HomeError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      state.message,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is HomeEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'No characters found',
                      style: AppTextStyles.body,
                    ),
                  ),
                );
              }

              if (state is HomeLoaded) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: state.characters.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1.h,
                    color: Colors.black12,
                  ),
                  itemBuilder: (context, index) {
                    final c = state.characters[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      title: Text(
                        c.name,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${c.species} • ${c.gender}',
                        style: AppTextStyles.caption,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(999.r),
                        child: Image.network(
                          c.image,
                          width: 44.w,
                          height: 44.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 44.w,
                            height: 44.w,
                            alignment: Alignment.center,
                            color: Colors.black12,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(
                          'detail',
                          pathParameters: {'id': '${c.id}'},
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
