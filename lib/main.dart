import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injector.dart';
import 'core/routes/app_router.dart';

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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bigio Rick & Morty',
      routerConfig: appRouter.router,
      theme: ThemeData(
        useMaterial3: true
      ),
    );
  }
}