import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injector.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/characters/presentation/bloc/favorites_sync/favorites_sync_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return BlocProvider<FavoritesSyncCubit>(
          create: (_) => sl<FavoritesSyncCubit>()..load(),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Bigio Rick & Morty',
            routerConfig: appRouter.router,
            theme: AppTheme.light(),
          ),
        );
      },
    );
  }
}
